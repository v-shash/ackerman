from typing import Dict
from .Limit import Limit
from datetime import timedelta
from .LogLine import LogLine


class LimitProcessor:
    ipToRequestListMap: Dict
    limit: Limit

    @staticmethod
    def getUnexpired(expiredTime, array):
        # do not really need to iterate over all of the array. it's sorted.
        # just locate first
        return [i for i in array if i.getTime() > expiredTime]
        # first_index = np.searchsorted([x.getTime() for x in array],timestamp)
        # return np.array(array[first_index:len(array)])

    def __init__(self, limit: Limit):
        self.limit = limit
        self.ipToRequestListMap = {}

    def evictExpired(self, currTime):
        for ip in self.ipToRequestListMap:

            if (
                len(self.ipToRequestListMap[ip]) >= self.limit.numRequests - 2
            ):  # small hack to not evict everytime

                self.ipToRequestListMap[ip] = LimitProcessor.getUnexpired(
                    currTime - timedelta(seconds=self.limit.reqPeriodSeconds),
                    self.ipToRequestListMap[ip],
                )

    def processNewRequest(self, line: LogLine):

        # if matching a uri but uri not in new request, do not process
        if self.limit.uri:
            # print("limit uri: {0}, lineuri: {1}".format(self.limit.uri, line.getUrl()))
            if self.limit.uri != line.getUrl():
                return {}

        # append to request map
        if line.getIp() not in self.ipToRequestListMap:
            self.ipToRequestListMap[line.getIp()] = []
        self.ipToRequestListMap[line.getIp()].append(line)

        # processing banning
        ipToUnbanTimeMap = {}
        if len(self.ipToRequestListMap[line.getIp()]) >= self.limit.numRequests:
            # ban
            ipToUnbanTimeMap[line.getIp()] = line.getTime() + timedelta(
                seconds=self.limit.banTimeSeconds
            )

        return ipToUnbanTimeMap
