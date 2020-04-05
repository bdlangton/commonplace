# Website location

http://localhost:8085

# Starting and Stopping Docker

```
docker-compose up -d
docker-compose stop
```

When first starting up, you'll need to login to docker and bundle install:

```
docker exec -i commonplace-web sh -c "bundle install"
```

# Databases

Three databases will be installed and a backup DB needs to be installed in
`commonplace_dev` for regular development and `commonplace_test` for running
rspec tests. The `composer` database is just for production.

# Running tests

```
docker exec -i commonplace-web sh -c "RAILS_ENV=test bundle exec rspec spec/"
```
