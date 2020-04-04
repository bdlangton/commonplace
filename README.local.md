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

# Running tests

```
docker exec -i commonplace-web sh -c "RAILS_ENV=test bundle exec rspec spec/"
```
