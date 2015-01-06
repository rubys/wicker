wicker
======

Blogging software which is intended to replace the sofware used on [intertwingly](http://intertwingly.net/blog/).

Current status: work in progress.

Prerequisites:
---

* Install [Ruby](https://www.ruby-lang.org/en/) 1.9.3 or later.
* Install [bundler](http://bundler.io/) and [rake](http://docs.seattlerb.org/rake/).
* Install [PhantomJS](http://phantomjs.org/).

Installation instructions:
---

* `git clone https://github.com/rubys/wicker.git`
* `cd wicker`
* `rake`
* `RACK_ENV=test rackup`

The `rake` command will build test data and run acceptance tests.  The `rackup` command will run a web server with
this test data.
