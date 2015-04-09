# GitHub Followergraph
Small ruby scripts to obtain graphs of GitHub user's follower relation

Usage:
```shell
ruby discovery.rb 0123456789abcdef0123456789abcdef01234567
```
where _0123456789abcdef0123456789abcdef01234567_ is your personal access token, which you can get from here: https://github.com/settings/applications and which should cover the required permissions.

Calling ```discovery.rb``` will create two directories with json files containing followers and "followees"(?) of a certain github handle (the handle is in the file name).

```shell
ruby graphbuilder.rb
```
will create two files in [GEXF File Format](http://gexf.net) that contain all the users and their connections which it can find in the abovementioned two json-file-filled directories.

You will need to have Bundler installed and run ```bundle``` (recommended) or you will have to replace
```ruby
require 'bundler'
Bundler.require
```
with
```ruby
require 'json'
```
after manually installing this gem (why would you want to?!!)

# Fair License

&copy; 2015, Thomas Efer

Usage of the works is permitted provided that this instrument is retained with the works, so that any entity that uses the works is notified of this instrument.

DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
