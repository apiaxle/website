---
layout: docs
title: Statistics and Analytics in ApiAxle
showtoc: true
---

## Features of the ApiAxle statistics system

* Queryable by arbitrary times.
* Multiple formatting options like timeseries.
* Highly scalable in terms of memory usage.
* Uses a glob system to capture path information.
* Stats about keys, keyrings and apis - or a mix of those.
* Given a URL glob keep counters and timers.

## How the statistics system works

Before going into any detail about how to actually get the statistics
it's probably worth describing how they work. ApiAxle stores it's
timings, charts and counters in Reids in
[RRD](http://en.wikipedia.org/wiki/RRDtool) style. This means ApiAxle
can store lots of information starting at a high level of detail for
more recent data, and gradually widening the aggregates as the data
becomes older.

Internally, any class that wants to provide statistics gets the
following definition, or one like it:

    @granularities =
      second:
        value: tconst.seconds 1
        redis_ttl: tconst.hours 2
      minute:
        value: tconst.minutes 1
        redis_ttl: tconst.days 1
      hour:
        value: tconst.hours 1
        redis_ttl: tconst.weeks 1
      day:
        value: tconst.days 1
        redis_ttl: tconst.years 2

Nice and simple. Without worrying too much more about low-level
implementation details (you can always read the source), the
`Counters` object has a method `log` which, when called, will
increment a named counter. Each of the above granularity level will
have their named counters incremented and each counter will only live
for their retrospective `redis_ttl`. So, you can see two hours-worth
of second level data and two years-worth of day level data.

## So, what can ApiAxle capture?

Taking one of the
[Guardian APIs](http://www.theguardian.com/open-platform) as an
example, with the following setup in a local ApiAxle instance:

    axle> api guardian create endPoint="content.guardianapis.com"

    axle> key frankbruno create
    axle> key miketyson create

    axle> api guardian linkkey frankbruno
    axle> api guardian linkkey miketyson

And a keyring to group our keys:

    axle> keyring boxers create
    axle> keyring boxers linkkey miketysonk
    axle> keyring boxers linkkey frankbruno

This registers the guardian API and two keys which are linked to that
API and can make calls to it. To make it a bit more interesting lets
say we want to capture the `/search` path specifically too:

    axle> api guardian addcapturepath "/search?q=*"

This says, match exactly except `q` can be equal to anything.

Let's make a test call:

    $ curl 'http://guardian.api.localhost:3000/search?q=debate&format=json&api_key=frankbruno'
    
This yields the results we would expect from that API. Now lets see
what ways we can see that information:

### Counters

Provides a simple counter that'll increment each time a match
occurs. There's an implicit match for every call made by every key to
an API. Given the call we made above let's explore ApiAxle's own API:


    $ curl 'http://localhost:5000/v1/api/guardian/stats?granularity=hour&format_timestamp=ISO'

Gives us:

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "uncached": {
          "2013-08-27T15:00:00.000Z": {
            "200": 1
          }
        },
        "cached": {},
        "error": {}
      }
    }

One call in the current hour, you can swap hour in this case for
second, minute or day. Let's wait and then hit the API a few more
times and see what else we can get:

    $ siege -c 3 -i -t24h 'http://guardian.api.localhost:3000/search?q=debate&format=json&api_key=frankbruno'

Don't worry, by default keys can only do two queries a second, we're
not going to take down the Guardian.

Now ApiAxle's API tells us:

    $ curl 'http://localhost:5000/v1/api/guardian/stats?granularity=hour&format_timestamp=ISO'

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "uncached": {
          "2013-08-27T15:00:00.000Z": {
            "200": 71
          }
        },
        "cached": {},
        "error": {
          "2013-08-27T15:00:00.000Z": {
            "QpsExceededError": 107,
            "EndpointTimeoutError": 7
          }
        }
      }
    }

Let's ask for the same thing with a second-level granularity. I've
snipped the results for the sake of readability:

    $ curl 'http://localhost:5000/v1/api/guardian/stats?granularity=second&format_timestamp=ISO'

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "uncached": {
          "2013-08-27T15:06:26.000Z": { "200": 1 },
          "2013-08-27T15:09:56.000Z": { "200": 1 },
          "2013-08-27T15:09:57.000Z": { "200": 2 },
          "2013-08-27T15:09:58.000Z": { "200": 1 },
          "2013-08-27T15:09:59.000Z": { "200": 1 },
          [ snip... ]
          "2013-08-27T15:10:34.000Z": { "200": 2 },
          "2013-08-27T15:10:35.000Z": { "200": 2 },
          "2013-08-27T15:10:36.000Z": { "200": 2 },
          "2013-08-27T15:10:37.000Z": { "200": 2 },
          "2013-08-27T15:10:38.000Z": { "200": 2 }
        },
        "cached": {},
        "error": {
          "2013-08-27T15:09:56.000Z": { "QpsExceededError": 1 },
          "2013-08-27T15:09:57.000Z": { "QpsExceededError": 2 },
          "2013-08-27T15:09:58.000Z": { "QpsExceededError": 6 },
          "2013-08-27T15:09:59.000Z": { "QpsExceededError": 4 },
          "2013-08-27T15:10:01.000Z": { "EndpointTimeoutError": 1 },
          "2013-08-27T15:10:02.000Z": { "EndpointTimeoutError": 2 },
          "2013-08-27T15:10:04.000Z": {
            "QpsExceededError": 2,
            "EndpointTimeoutError": 2
          },
          "2013-08-27T15:10:05.000Z": { "EndpointTimeoutError": 1 },
          "2013-08-27T15:10:07.000Z": {
            "QpsExceededError": 4,
            "EndpointTimeoutError": 1
          },
          "2013-08-27T15:10:08.000Z": { "QpsExceededError": 7 },
          "2013-08-27T15:10:10.000Z": { "QpsExceededError": 2 },
          [ snip... ]
          "2013-08-27T15:10:31.000Z": { "QpsExceededError": 1 },
          "2013-08-27T15:10:33.000Z": { "QpsExceededError": 1 },
          "2013-08-27T15:10:34.000Z": { "QpsExceededError": 6 },
          "2013-08-27T15:10:35.000Z": { "QpsExceededError": 4 },
          "2013-08-27T15:10:38.000Z": { "QpsExceededError": 2 }
        }
      }
    }

The calls here all support the `forkey` and `forkeyring` query
parameter which allows me to narrow down results even further.

Make a new call as miketyson:

    $ curl 'http://guardian.api.localhost:3000/search?q=debate&format=json&api_key=miketyson'

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "uncached": {
          "2013-08-27T00:00:00.000Z": {
            "200": 1
          }
        },
        "cached": {},
        "error": {}
      }
    }

For all of the boxers combined:

    $ curl 'http://guardian.api.localhost:3000/search?q=debate&format=json&api_key=miketyson'

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "uncached": {
          "2013-08-27T00:00:00.000Z": {
            "200": 72
          }
        },
        "cached": {},
        "error": {
          "2013-08-27T00:00:00.000Z": {
            "QpsExceededError": 107,
            "EndpointTimeoutError": 7
          }
        }
      }
    }

#### Endpoint capturing

As implied above it's possible to capture individual paths too. We
did:

    axle> api guardian addcapturepath "/search?q=*"

So all of the above calls should have been caught on this path:

    $ curl 'http://localhost:5000/v1/api/guardian/capturepaths/stats/counters?granularity=day&format_timestamp=ISO'

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "/search?q=*": {
          "1377561600": "72"
        }
      }
    }

Capturepaths also supports `forkeyring` and `forkey` for more
narrowing.

### Charts

Charts allow you to see the top callers for an API. This is useful for
large-screen statistics:

100 busiest keys for an API (busiest first):

    $ curl 'http://localhost:5000/v1/api/guardian/keycharts?granularity=day'

    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "frankbruno": 185,
        "miketyson": 1
      }
    }

100 busiest APIs (busiest first):

    $ curl 'http://localhost:5000/v1/apis/charts?granularity=day'
    
    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "guardian": 186
      }
    }

100 Busiest APIs for a key (busiest first):

    $ curl 'http://localhost:5000/v1/key/miketyson/apicharts?granularity=day'
    
    {
      "meta": {
        "version": 1,
        "status_code": 200
      },
      "results": {
        "guardian": 1
      }
    }

### Timers - min, max, rolling mean
