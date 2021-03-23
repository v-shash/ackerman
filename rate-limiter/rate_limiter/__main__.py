import argparse
from rate_limiter.Parser import Parser
from rate_limiter.IPRateLimiter import IpRateLimiterBuilder
from rate_limiter.Limit import Limit
import urllib.request



if __name__ == "__main__":

    # Instantiate the argument parser
    parser = argparse.ArgumentParser(description='Rate Limiter Log Parser')

    parser.add_argument('--file_path', dest='file_path', action='store',
                        help='File to be parsed', required=False)

    args = parser.parse_args()

    file_path = args.file_path

    if (not file_path):
        print("file_path not passed. Will retrieve file from s3")
        ## temporary
        url = "https://mhusseini-public-bucket.s3.amazonaws.com/ProdE-TestQ2.log"
        urllib.request.urlretrieve(url, "file.log")
        file_path = "file.log"

    limit1 = Limit(40, 60, '', 10*60)
    limit2 = Limit(100, 60*10, '', 60*60)
    limit3 = Limit(20, 10*60, '/login', 2*60*60)

    file_parser = Parser()

    limiter = IpRateLimiterBuilder().addFile(file_parser, filePath=file_path).addLimit(limit1).addLimit(limit2).addLimit(limit3).build()


    limiter.run();

