from typing import Dict, List



class Limit:
    numRequests = 0
    reqPeriodSeconds = 0
    uri = ''
    banTimeSeconds = 0

    def __init__(self, numRequests, reqPeriodSeconds, uri, banTimeSeconds) -> None:
        self.numRequests = numRequests
        self.reqPeriodSeconds = reqPeriodSeconds
        self.uri = uri
        self.banTimeSeconds = banTimeSeconds