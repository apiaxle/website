---
layout: docs
title: "Why use ApiAxle?"
description: "Why you should use us over what's already out there."
hidetoc: true
---

## Open Source

You have the source code. You can read it, edit it, fork it, improve
it and re-contribute it. On top of all of that, you benefit from
others doing the same.

We're hosted on Github and will happily review pull requests with the
possibility of merging them into master.

## Locally hosted

You host ApiAxle within your firewall. This means:

 * You **minimise latency costs** by avoiding the cloud.
 * You know exactly where **your data** is going and who can see
   it. No concerns about someone caching sensitive data for too long
   because you're in charge.
 * Absolute control over infrastructure. Choose Nginx, Lighttpd,
   Varnish, Apache or none of the above. Tune Redis to your liking or
   [have us do it](mailto:support@apiaxle.com) according to your
   specific API requirements.

## Cost

The proxy, repl and API parts of ApiAxle are totally free. This means
you can get a working system for zero cost. As your needs start to
grow [get in touch](mailto:support@apiaxle.com) for support contracts
or consultancy.

Soon we will have an enterprise-ready dashboard which will wrap the
Axle API and integrate with other systems to keep you up to date with
trends and usage of *your* API.

## Feature rich

Choosing ApiAxle will get you:

 * Thanks to our API integrating us into your current user paradigm is
   very easy. Just call `create` then `linkkey` and you're done!
 * HMAC token authentication based on secret key and epoch hashing.
 * Rate limiting - limit keys to a number of calls per second or calls per day.
 * [Caching](http://apiaxle.com/docs/caching/) - set global caches or
   use proxy style cache-control headers to cache on a per call basis.
 * Speed - we keep a close eye on how Axle performs. It's very fast.
 * Redirection limits, timeout configuration.
 * JSON or XML error output.
 * HTTPS support.
 * Highly [configurable logging](http://apiaxle.com/docs/configuration/).
 
## Powerful API

ApiAxle has its own, [powerful](http://apiaxle.com/api.html) API. You
can provision, update, delete and view keys, APIs and keyrings. You
can get detailed and real-time statistics for keys and APIs with
narrowing and filtering down to a per-second level of granularity.

## Powerful REPL

ApiAxle also provides a command line repl which mirrors the API
functionality. Want to provision a new key?

    axle> key "2e31852b4d9834" create
    axle> api "stock" linkkey "2e31852b4d9834"
    
That's it. Easily scriptable if you don't want to have to host the
API.
