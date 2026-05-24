# syntax=docker/dockerfile:1.7

ARG RUBY_VERSION=3.3.5
FROM ruby:${RUBY_VERSION}-slim AS base

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        default-libmysqlclient-dev \
        default-mysql-client \
        git \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
        nodejs \
        pkg-config \
        pngcrush \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

# xiv-data game data is NOT baked into the image — the data-updater container
# clones / updates it into a shared named volume at runtime. Keeps the base
# image lean and means a single `compose up` picks up new game data without
# requiring an image rebuild.

COPY . .

# Strip CRLF that Windows hosts inject so Linux can exec scripts/shebangs.
RUN sed -i 's/\r$//' bin/* docker/entrypoint.sh

# Preserve a read-only backup of the repo-tracked image dirs so the updater can
# cp -n them into the externally-bind-mounted live dirs on first run. Without
# this, bind mounts would mask repo-tracked files (e.g. mounts/pickorpokkur.png,
# hairstyles/228/*) in the container's view.
RUN mkdir -p /image-assets \
    && cp -r /app/public/images /image-assets/public-images \
    && cp -r /app/app/assets/images /image-assets/app-assets-images

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh \
    && chmod +x bin/*

EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]


FROM base AS dev

ENV RAILS_ENV=development

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]


FROM base AS prod

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

RUN bundle config set --local without 'development test' \
    && bundle install \
    && bundle clean --force

# SECRET_KEY_BASE_DUMMY lets assets:precompile run without the real master key
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
