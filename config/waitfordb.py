#!/usr/bin/python

from __future__ import print_function

import argparse
import pymysql
import time


def parse_args():
    p = argparse.ArgumentParser(add_help=False)

    p.add_argument('--help', action='help', default=argparse.SUPPRESS)

    p.add_argument('--host', '-h')
    p.add_argument('--user', '-u')
    p.add_argument('--password', '--pass', '-p')
    p.add_argument('database')

    return p.parse_args()


def main():
    args = parse_args()

    while True:
        try:
            conn = pymysql.connect(
                user=args.user,
                password=args.password,
                host=args.host,
                database=args.database)

            curs = conn.cursor()
            curs.execute('select 1')
            break
        except pymysql.err.OperationalError as err:
            print('connection to database {} failed: {}'.format(
                args.database, err))
            time.sleep(1)


if __name__ == '__main__':
    main()
