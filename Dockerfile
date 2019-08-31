FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /ffxiv-collect
WORKDIR /ffxiv-collect
COPY Gemfile /ffxiv-collect/Gemfile
COPY Gemfile.lock /ffxiv-collect/Gemfile.lock
RUN bundle install
COPY . /ffxiv-collect
RUN chmod +x ./docker-entrypoint.sh

RUN bundle exec rake app:update:bin
EXPOSE 3000

# Start the main process.
CMD ["./docker-entrypoint.sh"]