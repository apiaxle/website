---
layout: docs
title: Statistics and Analytics in ApiAxle
showtoc: true
---

## Features of the ApiAxle statistics system

* Queryable by arbitrary times.
* Multiple formatting options like `timeseries`.
* Highly scalable in terms of memory usage.
* Uses a glob system to capture path information.
* Stats about keys, keyrings and apis - or a mix of those.

## How the statistics system works

Before going into any detail about how to actually get the statistics
it's probably worth describing how they work. ApiAxle stores it's
timings, charts and counters in Reids in
[RRD](http://en.wikipedia.org/wiki/RRDtool) style. This means ApiAxle
can store lots of information starting at a high level of detail and
gradually widening the aggregates as the data becomes older.

Internally, any class that wants to provide statistics gets the
following definition, or, one like it:

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
implementation details, lets take counters and minutes as an
example. The `Counters` object has a method `log` which, when called,
will increment a named counter. Each of the above granularities will
have their named counters incremented and each counter will only live
for their retrospective `redis_ttl`. So, counters at a seconds
granularity, will live for two hours.

## So, what can ApiAxle capture?

## Examples of the different types in ApiAxle

### Counters

### Charts

### Timers
