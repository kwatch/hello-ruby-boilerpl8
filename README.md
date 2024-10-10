Hello-Ruby
==========

($Release: 0.2.0 $)


About
-----

This is a sample Ruby project to create a script which prints just "Hello, World!".
This repository can be used as a boilerplate for Ruby projects.


How To
------

```console
$ gem install boilerpl8
$ boilerpl8 github:kwatch/hello-ruby myproject
$ cd myproject
$ RUBYLIB=$PWD/lib bin/hello
Hello, World!
```


Changes
-------

### Release 0.2.0

* Rewrite `lib/hello.rb`.
* Add `rake/*_task.rb` files.
* Define new `help` task which is a default task.
* Define new `task:all` task which runs tests on multiple Ruby versions.
* Define new `clean` task instead of using `rake/clean`.
* Define new `release:wizard` task.
* Rename `howto` task to `release:howto`.
* Rename `package` task to `gem:build`.
* Rename `release` task to `gem:publish`.
* Include user account name into gemspec file.


### Release 0.1.0

* First public release.


License
-------

Public Domain

(License of hello-ruby-boilerpl8 repository is public domain,
 but your project can adpot MIT or other license what you like.)
