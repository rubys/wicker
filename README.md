wicker
======

Blogging software which is intended to replace the sofware used on [intertwingly](http://intertwingly.net/blog/).

Current status: work in progress.

Prerequisites:
---

* Install [Ruby](https://www.ruby-lang.org/en/) 1.9.3 or later.
* Install [bundler](http://bundler.io/) and [rake](http://docs.seattlerb.org/rake/).
* Install [PhantomJS](http://phantomjs.org/).
 
[![Build Status](https://travis-ci.org/rubys/wicker.svg)](https://travis-ci.org/rubys/wicker)

Installation instructions:
---

* `git clone https://github.com/rubys/wicker.git`
* `cd wicker`
* `rake`
* `RACK_ENV=test rackup`

The `rake` command will build test data and run acceptance tests.  The `rackup` command will run a web server with
this test data.

Design Goals
---

* Clean, uniformly indented, markup for all generated HTML and Atom feeds.
* Run on everything from [lynx](http://lynx.isc.org/) to 
  [evergreen browsers](http://www.yeti.co/blog/evergreen-web-browser).
* Direct use of modern JavaScript APIs (as opposed to the current software used on intertwingly builds on JQuery).
  This means that users of backlevel browsers may sometimes see the fallback behavior.
* Switch from a custom [MoinMoin](http://moinmo.in/) inspired comment syntax to a
  [MarkDown](https://help.github.com/articles/github-flavored-markdown/) comment syntax.
