from rate_limiter.LogLine import LogLine
import os
import re


class Parser:
    ipPattern = r"((([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])[ (\[]?(\.|dot)[ )\]]?){3}([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]))"
    # urlPattern = r"(\/\w+)(?: HTTP)"
    urlPattern = r"((GET|POST|HEAD) )(.*)(?: HTTP)"
    timePattern = r"\[(.*?)\]"


    def parse(self, filePath):
        if not os.path.isfile(filePath):
            raise Exception("File does not exist")

        logLineList = []

        try:
            f = open(filePath, "r")
        except:
            raise Exception("Error opening file with path: {0}".format(filePath))

        for line in f:
            try:
                ip = re.search(self.ipPattern, line).group(1)
                uri = re.search(self.urlPattern, line).group(3)
                time = re.search(self.timePattern, line).group(1)
                logLine = LogLine(ip, uri, time)
                logLineList.append(logLine)
            except:
                raise Exception("Error parsing the file for ip, url, and time regex patterns. Consider revisiting the Parser")

        return logLineList


