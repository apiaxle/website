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

Nice and simple. Without worrying too much about low-level
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
      meta: {
        version: 1,
        status_code: 200
      },
      results: {
        uncached: {
          "2013-08-25T21:00:00.000Z": { 200: 1 }
        },
        cached: { },
        error: { }
      }
    }

One call in the current hour, you can swap hour in this case for
second, minute or day. Let's wait and then hit the API a few more
times and see what else we can get:

    $curl 'http://localhost:5000/v1/api/guardian/stats?granularity=hour&format_timestamp=ISO'

Now gives us:

    {
      meta: {
        version: 1,
        status_code: 200
      },
      results: {
        uncached: {
          2013-08-25T21:00:00.000Z: { 200: 12 }
        },
        cached: { },
        error: {
          2013-08-25T21:00:00.000Z: { QpsExceededError: 5 }
        }
      }
    }

This shows that I had five QPS (queries per second) errors and
successfully called the API 12 times.

    {
      meta: {
        version: 1,
        status_code: 200
      },
      results: {
        uncached: {
          2013-08-25T21:44:23.000Z: { 200: 1 },
          2013-08-25T21:44:25.000Z: { 200: 1 },
          2013-08-25T21:44:26.000Z: { 200: 2 },
          2013-08-25T21:44:27.000Z: { 200: 1 },
          2013-08-25T21:44:28.000Z: { 200: 2 },
          2013-08-25T21:44:29.000Z: { 200: 1 },
          2013-08-25T21:44:30.000Z: { 200: 2 }
        },
        cached: { },
        error: {
          2013-08-25T21:44:30.000Z: { QpsExceededError: 4 },
        }
      }
    }

By asking for second granularity I've shown when exactly I've made the
calls. Each of the QpsExceededErrors were made in the same second.

### Charts

### Timers - min, max, rolling mean
