# KM

## Bootstrap app

```rb
cd config && cp database.yml{.sample,} && cd -
```

## Regenerate database

```rb
rake db:drop; rake db:create; rake db:migrate; rake db:populate
```

## Rebuild ElasticSearch

```sh
rake searchkick:reindex CLASS=Document; rake searchkick:reindex CLASS=User
```
