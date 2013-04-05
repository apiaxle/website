---
layout: apidocs
title: "Api documentation (generated from 'develop'"
---
This documentation was generated from branch 'develop'
# /v1/api/:api
## Provision a new API. (POST)
### JSON fields supported

* globalCache: The time in seconds that every call under this API should be cached.
* endPoint: The endpoint for the API. For example; `graph.facebook.com`
* protocol: (default: http) The protocol for the API, whether or not to use SSL
* apiFormat: (default: json) The resulting data type of the endpoint. This is redundant at the moment but will eventually support both XML too.
* endPointTimeout: (default: 2) Seconds to wait before timing out the connection
* endPointMaxRedirects: (default: 2) Max redirects that are allowed when endpoint called.
* extractKeyRegex: Regular expression used to extract API key from url. Axle will use the **first** matched grouping and then apply that as the key. Using the `api_key` or `apiaxle_key` will take precedence.
* defaultPath: An optional path part that will always be called when the API is hit.
* disabled: Disable this API causing errors when it's hit.

### Returns

* The inserted structure (including the new timestamp fields).

## Get the definition for an API. (GET)
### Returns

* The API structure (including the timestamp fields).

## Delete an API. (DELETE)
### Returns

* `true` on success.

## Update an API. (PUT)
Will merge fields you pass in.

### JSON fields supported

* globalCache: The time in seconds that every call under this API should be cached.
* endPoint: The endpoint for the API. For example; `graph.facebook.com`
* protocol: (default: http) The protocol for the API, whether or not to use SSL
* apiFormat: (default: json) The resulting data type of the endpoint. This is redundant at the moment but will eventually support both XML too.
* endPointTimeout: (default: 2) Seconds to wait before timing out the connection
* endPointMaxRedirects: (default: 2) Max redirects that are allowed when endpoint called.
* extractKeyRegex: Regular expression used to extract API key from url. Axle will use the **first** matched grouping and then apply that as the key. Using the `api_key` or `apiaxle_key` will take precedence.
* defaultPath: An optional path part that will always be called when the API is hit.
* disabled: Disable this API causing errors when it's hit.

### Returns

* The merged structure (including the timestamp fields).

# /v1/api/:api/keys
## List keys belonging to an API. (GET)
### Supported query params

* from: The index of the first key you want to see. Starts at zero.
* to: (default: 10) The index of the last key you want to see. Starts at zero.
* resolve: If set to `true` then the details concerning the listed keys will also be printed. Be aware that this will come with a minor performace hit.

### Returns

* Without `resolve` the result will be an array with one key per
  entry.
* If `resolve` is passed then results will be an object with the
  key name as the key and the details as the value.

# /v1/api/:api/linkkey/:key
## Associate a key with an API meaning calls to the API can be made
with the key.

The key must already exist and will not be modified by this
operation. (PUT)
### Returns

* The linked key details.

# /v1/api/:api/stats
## Get stats for an api. (GET)
### Supported query params

* from: (default: 1365170511) The unix epoch from which to start gathering the statistics. Defaults to `now - 10 minutes`.
* to: (default: 1365171111) The unix epoch from which to finish gathering the statistics. Defaults to `now`.
* granularity: (default: minutes) One of: seconds, minutes, hours, days. Allows you to gather statistics tuned to this level of granularity. Results will still arrive in the form of an epoch to results pair but will be rounded off to the nearest unit.

### Returns

* Object where the keys represent the cache status (cached, uncached or
  error), each containing an object with response codes or error name,
  these in turn contain objects with timestamp:count

# /v1/api/:api/unlinkkey/:key
## Disassociate a key with an API meaning calls to the API can no
longer be made with the key.

The key will still exist and its details won't be affected. (PUT)
### Returns

* The unlinked key details.

# /v1/apis
## List all APIs. (GET)
### Supported query params

* from: Integer for the index of the first api you want to see. Starts at zero.
* to: (default: 10) Integer for the index of the last api you want to see. Starts at zero.
* resolve: If set to `true` then the details concerning the listed apis will also be printed. Be aware that this will come with a minor performace hit.

### Returns

* Without `resolve` the result will be an array with one api per
  entry.
* If `resolve` is passed then results will be an object with the
  api name as the api and the details as the value.

# /v1/info
## Information about this project. (GET)
### Returns

* Package file output.

# /v1/key/:key
## Provision a new key. (POST)
### JSON fields supported

* sharedSecret: A shared secret which is used when signing a call to the api.
* qpd: (default: 172800) Number of queries that can be called per day. Set to `-1` for no limit.
* qps: (default: 2) Number of queries that can be called per second. Set to `-1` for no limit.
* forApis: Names of the Apis that this key belongs to.
* disabled: Disable this API causing errors when it's hit.

### Returns

* The newly inseted structure (including the new timestamp
  fields).

## Delete a key. (DELETE)
### Returns

* `true` on success.

## Get the definition of a key. (GET)
### Returns

* The key object (including timestamps).

## Update a key. (PUT)
Fields passed in will will be merged with the old key
details. Note that in the case of updating a key's `QPD` it will
get the new amount of calls minus the amount of calls it has
already made.

### JSON fields supported

* sharedSecret: A shared secret which is used when signing a call to the api.
* qpd: (default: 172800) Number of queries that can be called per day. Set to `-1` for no limit.
* qps: (default: 2) Number of queries that can be called per second. Set to `-1` for no limit.
* forApis: Names of the Apis that this key belongs to.
* disabled: Disable this API causing errors when it's hit.

### Returns

* The newly inseted structure (including the new timestamp
  fields).

# /v1/key/:key/apis
## List apis belonging to a key. (GET)
### Supported query params

* from: The index of the first api you want to see. Starts at zero.
* to: (default: 10) The index of the last api you want to see. Starts at zero.
* resolve: If set to `true` then the details concerning the listed apis will also be printed. Be aware that this will come with a minor performace hit.

### Returns

* Without `resolve` the result will be an array with one key per
  entry.
* If `resolve` is passed then results will be an object with the
  key name as the key and the details as the value.

# /v1/key/:key/stats
## Get the real time hits for a key. (GET)
### Returns

* Object where the keys represent the cache status (cached, uncached or
  error), each containing an object with response codes or error name,
  these in turn contain objects with timestamp:count

# /v1/keyring/:keyring
## Get the definition for an KEYRING. (GET)
### Returns

* The KEYRING structure (including the timestamp fields).

## Delete an KEYRING. (DELETE)
### Returns

* `true` on success.

## Update an KEYRING. (PUT)
Will merge fields you pass in.

### JSON fields supported



### Returns

* The merged structure (including the timestamp fields).

## Provision a new KEYRING. (POST)
### JSON fields supported



### Returns

* The inserted structure (including the new timestamp fields).

# /v1/keyring/:keyring/keys
## List keys belonging to an KEYRING. (GET)
### Supported query params

* from: The index of the first key you want to see. Starts at zero.
* to: (default: 10) The index of the last key you want to see. Starts at zero.
* resolve: If set to `true` then the details concerning the listed keys will also be printed. Be aware that this will come with a minor performace hit.

### Returns

* Without `resolve` the result will be an array with one key per
  entry.
* If `resolve` is passed then results will be an object with the
  key name as the key and the details as the value.

# /v1/keyring/:keyring/linkkey/:key
## Associate a key with a KEYRING.

The key must already exist and will not be modified by this
operation. (PUT)
### Returns

* The linked key details.

# /v1/keyring/:keyring/unlinkkey/:key
## Disassociate a key with a KEYRING.

The key will still exist and its details won't be affected. (PUT)
### Returns

* The unlinked key details.

# /v1/keyrings
## List all KEYRINGs. (GET)
### Supported query params

* from: Integer for the index of the first keyring you want to see. Starts at zero.
* to: (default: 10) Integer for the index of the last keyring you want to see. Starts at zero.
* resolve: If set to `true` then the details concerning the listed keyrings will also be printed. Be aware that this will come with a minor performace hit.

### Returns

* Without `resolve` the result will be an array with one keyring per
  entry.
* If `resolve` is passed then results will be an object with the
  keyring name as the keyring and the details as the value.

# /v1/keys
## List all of the available keys. (GET)
### Supported query params

* from: The index of the first key you want to see. Starts at zero.
* to: (default: 10) The index of the last key you want to see. Starts at zero.
* resolve: If set to `true` then the details concerning the listed keys will also be printed. Be aware that this will come with a minor performace hit.

### Returns

* Without `resolve` the result will be an array with one key per
  entry.
* If `resolve` is passed then results will be an object with the
  key name as the key and the details as the value.

