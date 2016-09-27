---
layout: docs
title: "How to contribute to ApiAxle"
description: "How to contribute to ApiAxle"
permalink: /docs/how-to-contibute-to-apiaxle/
---

Thinking of adding a feature? That's great - we obviously encourage
contributions and would love to help you. To start you off, here's a
quick guide for getting up and running on an Ubuntu type system:

## Email us

It's worth checking with us to see if the feature is in development or
on the roadmap. We may have already written a spec in which case you
could save time by using that or, if you can, waiting for us to
develop it.

## Installing the dependencies

    $ sudo apt-get install nodejs build-essential libxml2-dev

## Fork and clone

Login to github, go to https://github.com/apiaxle/apiaxle/, hit the
fork button and then clone your fork.

## Install the dependencies

    $ cd apiaxle
    $ make npminstall

ApiAxle uses a library called `apiaxle-base` for things like
configuration, test helpers, logging etc. Because you want to symlink
the one in your clone, and not the one from npm. Anyway, this will do
that for you:

    $ make link clean

Now install Coffeescript and twerp globally:

    $ [sudo] npm install -g coffee-script twerp

## Run the tests

    $ make test

## Hack!

Now you can add your features and tests. Once you're done submit a
pull-request and hopefully your stuff will be merged.
