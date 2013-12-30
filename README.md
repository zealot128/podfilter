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

If you want to use omniauth logins in Development, you have to add some keys/secrets to .env.development.

```
TWITTER_CONSUMER_KEY=something
TWITTER_CONSUMER_SECRET=something

GITHUB_CONSUMER_KEY=something
GITHUB_CONSUMER_SECRET=something
```



### What could be done?

* Logo/favicon
* categorization
* recommendations improvements
* Stylings
* more community/comment/like aspects
* follow redirects. example http://learn.thoughtbot.com/podcast.xml
