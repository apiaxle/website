---
layout: "default"
title: "A hint at performance"
description: "A fairly unscientific look at ApiAxle's performance."
---

# A hint at performance

* On my not-particularly-fancy desktop machine.
* 200 concurrent connections.
* Nginx balancing over four instances of ApiAxle. 
* Against a test API which sends small amounts of random data with a
  random latency (hence the 504's when a call times out).

## Ab output

    Finished 15000 requests
    $return_codes = {
              '200' => 23,
              '429' => 14966,
              '504' => 11
            };

    Data in /tmp/tmp.LXHMEuvD1l
    Time taken for tests:   12.805 seconds
    Complete requests:      15000
    Failed requests:        36
       (Connect: 0, Receive: 0, Length: 36, Exceptions: 0)
    Write errors:           0
    Non-2xx responses:      14977
    Total transferred:      20438944 bytes
    HTML transferred:       17543098 bytes
    Requests per second:    1171.41 [#/sec] (mean)
    Time per request:       170.735 [ms] (mean)
    Time per request:       0.854 [ms] (mean, across all concurrent requests)
    Transfer rate:          1558.74 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   2.2      0      22
    Processing:     2  112 204.4     86    5225
    Waiting:        2  112 204.4     86    5225
    Total:          2  112 204.5     87    5225

    Percentage of the requests served within a certain time (ms)
      50%     87
      66%    111
      75%    134
      80%    149
      90%    189
      95%    210
      98%    232
      99%    251
     100%   5225 (longest request)
