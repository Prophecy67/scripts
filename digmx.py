#!/usr/bin/python
"""Resolving """
import dns.resolver
import dns.exception


def getmxrecords():
    """Purpose to get the mx records through dnspython module"""
    with open('transport_domains.txt', 'r') as domains:
        for row in domains:
            try:
                answers = dns.resolver.query(row.rstrip(), 'MX')
                for rdata in answers:
                    print ('Domain', row.strip(), 'Host', rdata.exchange,
                           'has preference', rdata.preference)

            except dns.resolver.NXDOMAIN:
                continue
            except dns.resolver.NoNameservers:
                continue
            except dns.exception.Timeout:
                continue
            except dns.resolver.NoAnswer:
                continue


if __name__ == '__main__':
    getmxrecords()
