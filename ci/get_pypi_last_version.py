#! /usr/bin/env python
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                     description='Get the last Pypi version of a python package')
    parser.add_argument('package',
                        type=str,
                        help='Python package to check version.')
    args = parser.parse_args()
    try:
        import xmlrpclib
        pypi = xmlrpclib.ServerProxy('http://pypi.python.org/pypi')
    except:
        # For python 3.x
        import xmlrpc
        pypi = xmlrpc.client.ServerProxy('http://pypi.python.org/pypi')

    available = pypi.package_releases(args.package)
    if not available:
        print ('0')
    else:
        print (available[0])
