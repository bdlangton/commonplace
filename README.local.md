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

# Environment variables

The following environment variables are needed in the .env file:

RAILS_ENV (development, test, production)
PASSENGER_APP_ENV (development, test, production)
SECRET_KEY_BASE
MYSQL_ROOT_PASSWORD
MYSQL_HOST
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
MAIL_USERNAME (if sending emails)
MAIL_PASSWORD (if sending emails)

# Databases

Three databases will be installed and a backup DB needs to be installed in
`commonplace_dev` for regular development and `commonplace_test` for running
rspec tests. The `composer` database is just for production.

# Sending emails

```
docker exec -i commonplace-web sh -c "bundle exec rake email"
```

# Running tests

```
docker exec -i commonplace-web sh -c "RAILS_ENV=test bundle exec rspec spec/"
```
