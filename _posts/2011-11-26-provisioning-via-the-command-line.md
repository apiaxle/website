---
layout: docs
title: Provisioning a new API
description: "How setup APIs and keys via the command line."
---

Have a look at the options you can assign to an API by running this
command:

    $ ./bin/new-api.coffee --help
    
At time of writing the output is this:

    Usage: coffee /home/phil/tmp/apiaxle/bin/new-api.coffee [OPTIONS] [COMPANY NAME]

    OPTIONS:
      --end-point-timeout=INTEGER  (default: 5)
            The request will timeout after n seconds.

      --end-point-max-redirects=INTEGER  (default: 2)
            The maximum number of re-directs allowed for endpoint

      --end-point=STRING  (required)
            The endpoint (url) this api's api will listen at.

      --api-format=<json, xml>  (default: json)
            Format of the api.

So, to make a facebook proxy, do this:

    $ ./bin/new-api.coffee --end-point=graph.facebook.com facebook

# Provisioning a new key

In a similar process to creating an API, run the `new-key` script with
the `--help` flag:

    $ ./bin/new-key.coffee --help

Output at time of writing:

    Usage: coffee /home/phil/tmp/apiaxle/bin/new-key.coffee [OPTIONS] [KEY]

    OPTIONS:
      --qpd=INTEGER  (default: 86400)
            Queries per day.

      --qps=INTEGER  (default: 1)
            Queries per second.

      --for-api=STRING  (required)
            The api this key works with.
            
So, to make a key for the facebook API you created above:

    $ ./bin/new-key.coffee --for-api=facebook d41d8cd98f00b204e9800998ecf8427e

Tip: For a random(ish) key:

    $ ./bin/new-key.coffee --for-api=facebook $(echo $RANDOM | md5sum |  awk '{ print $1 }')
