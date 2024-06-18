---
title: DNS
author: Charles Reiss
...

# Your Task

1.  Write a recursive DNS resolver in `dns.py`, such that:

        python dns.py SERVER HOSTNAME1 HOSTNAME2 ...

    starts with the DNS server SERVER to resolve the IPv4 and IPv6 addresses for
    the hostnames HOSTNAME1 and HOSTNAME2.

2.  After resolving each hostnames, you should output JSON in the format described below.

3.  When making multiple queries, you must cache the intermediate results of the first
    query to avoid making queries on the second.

4.  Test your code by TBD.

5.  Submit your code by TBD.

# Output format

## Example

    {
        'result': ['1.2.3.4', '2.3.4.5', '2307::4'],
        'ttls': [...],
        'steps': [
            {
                'server-name': 'SERVER',
                'server-address': 'IPv4 ADDRESS',
                'cached': true,
            },
            {
                'server-name': 'SERVER2',
                'server-address': 'IPv4 ADDRESS2',
                'cached': false,
            },
            {
                'server-name': 'SERVER3',
                'server-address': 'IPv4 ADDRESS3',
                'cached': false,
            },
        ],
    }

