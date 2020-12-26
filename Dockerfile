FROM phusion/passenger-ruby26:1.0.12

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential rbenv yarn

# Set correct environment variables.
ENV APP_HOME /home/app/docroot

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY --chown=app:app docroot/ $APP_HOME
RUN bundle install
ADD nginx.conf /etc/nginx/sites-enabled/default

RUN rm -f /etc/service/nginx/down

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
