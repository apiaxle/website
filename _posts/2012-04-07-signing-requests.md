---
layout: docs
title: Signing requests
description: How to sign requests for extra security.
---

At the cost of a small performance hit, ApiAxle supports the signing
of requests. Here's how to use and set them up:

## What makes up a signed request

There are three parts which make up a signing key:

* **Shared secret** - this string is supplied on the provisioning of
  the key and will never be revealed in a HTTP request. You would pass
  this to the function that generates the HMAC sig.
* **Epoch** - the UNIX epoch (seconds since 1970-01-01). ApiAxle will
  allow for a six second (3 either way) clock drift.
* **Api key** - the standard key associated with the API.

## Enabling signing for an API key

The signing functionality actually lives with a key, not the API. This
means, when you provision a key via the command-line you do the
following:

    $ ./bin/new-key.coffee --for-api=facebook 1234 --shared-secret=bob-the-builder
    
Now the key `1234` must always carry with it a signed parameter, if it
doesn't then ApiAxle will throw an error and close the door on the
request.

## Signing a request as a client

To sign a request you'll need to replicate the following pseudo code
in whatever your language of choice is:

    date = epoch()
    api_key = "1234"
    shared_secret = "bob-the-builder"
    
    # assuming + is your string concatenation operator
    signature = hmac-sha1( shared_secret, date + api_key )
    
    # now call your end-point with the two query params
    http.GET "facebook.api.localhost?api_sig=$signature&api_key=$api_key"

You can pass the signature in as query parameters named either
`api_sig` or `apiaxle_sig`.

[HMAC-SHA1](http://en.wikipedia.org/wiki/Hash-based_message_authentication_code)
is a way of generating a authentication code that isn't susceptible to
hash length extension attacks. Common implementations:

* [node.js](http://nodejs.org/api/crypto.html#crypto_crypto_createhmac_algorithm_key)
* [python](http://docs.python.org/library/hmac.html#module-hmac)
* [php](http://php.net/manual/en/function.hash-hmac.php)
* [perl](http://search.cpan.org/~mshelor/Digest-SHA-5.72/lib/Digest/SHA.pm)
