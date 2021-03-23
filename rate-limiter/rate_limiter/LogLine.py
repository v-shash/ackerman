from datetime import datetime

class LogLine:
    ipString: str
    urlStr: str
    timeStr: str

    def __init__(self, ipStr, uriStr, timeStr):
        self.ipString = ipStr
        self.urlStr = uriStr
        self.timeStr = timeStr

    def getIp(self):
        return self.ipString

    def getUrl(self):
        return self.urlStr

    def getTime(self):
        timeFormat = "%d/%b/%Y:%H:%M:%S %z"
        time = datetime.strptime(self.timeStr, timeFormat)
        return time

