---
layout: docs
title: ApiAxle Configuration
description: How to configure ApiAxle
permalink: /docs/configuration/
---

## The configuration file

ApiAxle supports multiple environments. This is in part to aid
development as well as allowing users to deploy different instances
without having to worry about them treading on each others toes in
Redis or on the filesystem. To specify the environment, just set the
`NODE_ENV` environment variable. E.G, for the repl:

    NODE_ENV=integration apiaxle

The location of the configuration file takes into account the
environment and will be sought out in the following locations, using
the above as an example:

 * /etc/apiaxle/integration.json
 * $HOME/.apiaxle/integration.json
 * ./config/integration.json

## Logging

Internally ApiAxle uses
[log4js](https://github.com/nomiddlename/log4js-node). The
configuration passed to ApiAxle mirrors that passed to log4js with the
default being:

    logging: {
      level: "INFO",
      appenders: [
        {
          type: "file",
          filename: "<NODE_ENV>-<PORT>.log"
        }
      ]
    }

Where `NODE_ENV` is the environment given (e.g. `test`, `development`,
etc) and `PORT` is the port the application is currently running on.

### Levels

There are different logging levels supported, at the moment ApiAxle
only utilises `DEBUG` and `INFO`. The full list is:

 * DEBUG
 * INFO
 * WARN
 * ERROR
 * FATAL

### Appenders

log4js supports lots of appenders, you could log from
[hook.io](http://hook.io) to smtp to the console or all or any of the
above, it's really very powerful. Have a look at the official
[appenders](https://github.com/nomiddlename/log4js-node/wiki/Appenders)
wiki page in the log4js repo and you'll see what's on offer. Here's an
example in the mean time which shows how you would log to a file and
the console:

    logging: {
      level: "INFO",
      appenders: [
        {
          type: "file",
          filename: "/var/log/apiaxle/production.log"
        },
        {
          type: "console"
        }
      ]
    }

## Redis

Pretty self explanatory. The configuration required to access Redis,
typical configuration might be:

    "redis": {
      "host": "localhost",
      "port": 6379
    }

## Api pattern configuration

    Configuration used to match api names, i.e., keys.  It needs to have a
    matching group and it must be formatted for JSON so extra \'s may appear:

        "apiNameRegex": "^(.+?)\\.api\\."  (matches typical pattern, acme.api.org, and captures acme as the key)
