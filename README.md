http://www.podfilter.de

[![Build Status](https://travis-ci.org/zealot128/podfilter.de.png?branch=master)](https://travis-ci.org/zealot128/podfilter.de)
[![Code Climate](https://codeclimate.com/github/zealot128/podfilter.de.png)](https://codeclimate.com/github/zealot128/podfilter.de)

## Contribute:

Needs redis, imagemagick and postgresql on your host.

Fork, install/configure:

```
git clone https://github.com/YOURFORK/podfilter.de
cd podfilter.de
bundle
cp config/database.yml.example config/database.yml
rake db:migrate db:test:prepare
bundle exec rspec

rake db:seed

foreman start
# navigate to http://localhost:5000
# sidekiq background worker is also started
```


### What could be done?

* Logo/favicon
* search
* categorization improvements
* recommendations
* Twitter/ more oauth login
* Stylings
* OPML Export
* Take part without providing a OPML, e.g. by manually liking episodes
* more community/comment/like aspects

* follow redirects. example http://learn.thoughtbot.com/podcast.xml
* remove duplicates -> similar mp3/ogg links unification
