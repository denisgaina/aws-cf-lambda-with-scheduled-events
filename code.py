import os
from datetime import datetime
from urllib.request import Request, urlopen

SITE = os.environ['SITE']  # URL of the site to check, stored in the site environment variable
# SITE = "https://docs.aws.amazon.com/lambda/latest/dg/welcome.html"
EXPECTED = os.environ['EXPECTED']  # String expected to be on the page, stored in the expected environment variable
# EXPECTED = "What is AWS Lambda?"

def validate(res):
    '''
    Currently this simply checks whether the EXPECTED string is present.
    However, you could modify this to perform any number of arbitrary
    checks on the contents of SITE.
    '''
    return EXPECTED in res


def lambda_handler(event, context):
    time = str(datetime.now())
    print(f"Checking {SITE} at {time}...")
    try:
        req = Request(SITE, headers={'User-Agent': 'AWS Lambda'})
        if not validate(str(urlopen(req).read())):
            raise Exception('Validation failed')
    except:
        print('Check failed!')
        raise
    else:
        print('Check passed!')
        return time
    finally:
        print(f'Check complete at {time}')
