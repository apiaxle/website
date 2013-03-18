---
layout: apidocs
title: "Api documentation (generated from 'develop'"
---
This documentation was generated from branch 'develop'
# /v1/api/:api
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

### Returns

* The merged structure (including the timestamp fields).

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

### Returns

* The inserted structure (including the new timestamp fields).

## Get the definition for an API. (GET)
### Returns

* The API structure (including the timestamp fields).

## Delete an API. (DELETE)
### Returns

* `true` on success.

# /v1/api/:api/hits
## Get the statistics for an api. (GET)
### Returns

* Object where the keys represent timestamp for a given second
  and the values the amount of hits to the specified API for that second

# /v1/api/:api/hits/now
## Get the statistics for an api. (GET)
### Returns

* Integer, the number of hits to the API this second.
  Designed light weight real time statistics

# /v1/api/:api/keys
## List keys belonging to an API. (GET)
### Supported query params

* from: Integer for the index of the first key you want to
  see. Starts at zero.
* to: Integer for the index of the last key you want to
  see. Starts at zero.
* resolve: if set to `true` then the details concerning the listed
  keys will also be printed. Be aware that this will come with a
  minor performace hit.

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
## Get the statistics for an api. (GET)
### Returns

* Object where the keys represent the HTTP status code of the
  endpoint or the error returned by apiaxle (QpsExceededError, for
  example). Each object contains date to hit count pairs.

# /v1/api/:api/unlinkkey/:key
## Disassociate a key with an API meaning calls to the API can no
longer be made with the key.

The key will still exist and its details won't be affected. (PUT)
### Returns

* The unlinked key details.

# /v1/apis
## List all APIs. (GET)
### Supported query params

* from: Integer for the index of the first api you want to
  see. Starts at zero.
* to: Integer for the index of the last api you want to
  see. Starts at zero.
* resolve: if set to `true` then the details concerning the listed
  apis  will also be printed. Be aware that this will come with a
  minor performace hit.

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
## Update a key. (PUT)
Fields passed in will will be merged with the old key details.

### JSON fields supported

* sharedSecret: A shared secret which is used when signing a call to the api.
* qpd: (default: 172800) Number of queries that can be called per day. Set to `-1` for no limit.
* qps: (default: 2) Number of queries that can be called per second. Set to `-1` for no limit.
* forApis: Names of the Apis that this key belongs to.

### Returns

* The newly inseted structure (including the new timestamp
  fields).

## Delete a key. (DELETE)
### Returns

* `true` on success.

## Get the definition of a key. (GET)
### Returns

* The key object (including timestamps).

## Provision a new key. (POST)
### JSON fields supported

* sharedSecret: A shared secret which is used when signing a call to the api.
* qpd: (default: 172800) Number of queries that can be called per day. Set to `-1` for no limit.
* qps: (default: 2) Number of queries that can be called per second. Set to `-1` for no limit.
* forApis: Names of the Apis that this key belongs to.

### Returns

* The newly inseted structure (including the new timestamp
  fields).

# /v1/key/:key/hits
## Get hits for a key in the past minute. (GET)
### Returns

* Object where the keys represent timestamp for a given second
  and the values the amount of hits to the Key for that second

# /v1/key/:key/hits/now
## Get the real time hits for a key. (GET)
### Returns

* Integer, the number of hits to the Key this second.
  Designed light weight real time statistics

# /v1/key/:key/stats
## Get the statistics for a key. (GET)
### Returns

* Object where the keys represent the HTTP status code of the
  endpoint or the error returned by apiaxle (QpsExceededError, for
  example). Each object contains date to hit count pairs.

# /v1/keyring/:keyring
## Provision a new KEYRING. (POST)
### JSON fields supported



### Returns

* The inserted structure (including the new timestamp fields).

## Delete an KEYRING. (DELETE)
### Returns

* `true` on success.

## Update an KEYRING. (PUT)
Will merge fields you pass in.

### JSON fields supported



### Returns

* The merged structure (including the timestamp fields).

## Get the definition for an KEYRING. (GET)
### Returns

* The KEYRING structure (including the timestamp fields).

# /v1/keyring/:keyring/keys
## List keys belonging to an KEYRING. (GET)
### Supported query params

* from: Integer for the index of the first key you want to
  see. Starts at zero.
* to: Integer for the index of the last key you want to
  see. Starts at zero.
* resolve: if set to `true` then the details concerning the listed
  keys will also be printed. Be aware that this will come with a
  minor performace hit.

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

* from: Integer for the index of the first keyring you want to
  see. Starts at zero.
* to: Integer for the index of the last keyring you want to
  see. Starts at zero.
* resolve: if set to `true` then the details concerning the listed
  keyrings  will also be printed. Be aware that this will come with a
  minor performace hit.

### Returns

* Without `resolve` the result will be an array with one keyring per
  entry.
* If `resolve` is passed then results will be an object with the
  keyring name as the keyring and the details as the value.

# /v1/keys
## List all of the available keys. (GET)
### Supported query params
* from: Integer for the index of the first key you want to
  see. Starts at zero.
* to: Integer for the index of the last key you want to
  see. Starts at zero.
* resolve: if set to `true` then the details concerning the listed
  keys will also be printed. Be aware that this will come with a
  minor performace hit.

### Returns

* Without `resolve` the result will be an array with one key per
  entry.
* If `resolve` is passed then results will be an object with the
  key name as the key and the details as the value.

