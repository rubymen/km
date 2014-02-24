# KM

[![Coverage Status](https://coveralls.io/repos/rubymen/km/badge.png?branch=develop)](https://coveralls.io/r/rubymen/km?branch=develop)

## Bootstrap app

```rb
cd config && cp database.yml{.sample,} && cd -
git submodule init && git submodule update
```

## Regenerate database

```rb
rake db:drop; rake db:create; rake db:migrate; rake db:populate
```

## Rebuild ElasticSearch

```sh
rake searchkick:reindex CLASS=Document; rake searchkick:reindex CLASS=User
```

## Deploy

```rb
cap deploy:setup
cap uploads:setup
cap deploy
```

**Note**: you can prefix function by environment (usually, production or staging)
