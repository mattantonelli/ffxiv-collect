FROM ruby:2.4.1

ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /ffxiv-collect
WORKDIR /ffxiv-collect
COPY Gemfile /ffxiv-collect/Gemfile
COPY Gemfile.lock /ffxiv-collect/Gemfile.lock
RUN bundle install
COPY . /ffxiv-collect

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]