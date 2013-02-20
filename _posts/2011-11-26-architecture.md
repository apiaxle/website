---
layout: docs
title: "Architecture"
description: "Architecture overview."
---

# {{page.title}}

ApiAxle is effectively a HTTP proxy meaning it's really easy to slide
it into your existing architecture. Below is a simple diagram which
demonstrates the following:

* An Nginx server round-robin distributing requests from the internet
* Four instances of ApiAxle - we recommend running as many instances
  of the ApiAxle proxy as you have cores available.
* One Redis store which is used by both ApiAxle products.
* Once instance of the ApiAxle API - how many instances you have
  depends on how busy the API will be. 

![ApiAxle architecture diagram](http://github.com/apiaxle/apiaxle/raw/master/proxy/docs/sample-architecture.png)
