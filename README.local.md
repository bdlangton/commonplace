# Website location

http://localhost:8085

# Starting and Stopping Docker

```
docker-compose up -d
docker-compose stop
```

# Running tests

```
docker exec -i commonplace-web sh -c "RAILS_ENV=test bundle exec rspec spec/"
```
