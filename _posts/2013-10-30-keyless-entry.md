---
layout: docs
title: Keyless access
---

It's now possible to configure an API to allow keyless access. Here's
how:

    axle> update acmeapi allowKeylessUse=true

You can now fire a request to acmeapi and a key
will be created and used for that request. You can use `keylessQps`,
`keylessQpm`, and `keylessQpd` to set the rate limits applied to
keyless use for that api. E.G:

    axle> update acmeapi keylessQps=20 keylessQpd=40000

Now all keyless access to acmeapi will be allowed 20 hits a second and
40,000 hits per day.

**You can mix keyless and keyed access.**

## What happens behind the scenes

Assuming `allowKeylessUse` is `true`, when a keyless request comes in,
a new key will be created which looks like `ip-<ip address>`.
You can treat this key as you would any other. The only
difference is that you won't be able to set rate limit overrides as it
will always use the keylessQpd/Qpm/Qps values set on the API.

## Where's the IP address taken from

If the `x-forwarded-for` header is set this will be used, if not then
the IP address that opened the socket to the ApiAxle instance will be
used.

This means that in theory a user could send a false `x-forwarded-for`
header and gradually overload ApiAxle's datastore. Be sure to strip or
verify `x-forwarded-for` if this is a concern.
