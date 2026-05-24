# FFXIV Collect
This is a collection tracking companion website for Final Fantasy XIV collections written in [Ruby on Rails](https://rubyonrails.org/). Game data is powered by [XIVData Oxidizer](https://github.com/skyborn-industries/xiv-data-oxidizer). This application strives to be as autonomous as possible by pulling most of its information directly from the game data. The rest is maintained by myself and a small group of moderators using community-sourced data.

## API

All of this application's data is made available through a RESTful JSON API. See the [documentation](https://ffxivcollect.com/api/docs) for details.

## Dependencies
* Ruby (3.3.5)
* Rails (7.2.2)
* MariaDB / MySQL
* Redis
* pngcrush

## Installation
#### Clone and initialize the repository
```
git clone --recurse-submodules https://github.com/skyborn-industries/ffxiv-collect
cd ffxiv-collect
bundle install
```

#### Set up the database
Create the MySQL databases `ffxiv_collect_development` and `ffxiv_collect_test` as well as a database user with access to them

#### Create the necessary 3rd party applications
1. Create a new [Discord app](https://discord.com/developers/applications/) for user authentication. Take note of the **client ID** and **secret**.
    1. Set the redirect URI on the OAuth2 page of your app: `http://localhost:3000/users/auth/discord/callback`
2. Configure the credentials file to match the format below using your data.
```
rm config/credentials.yml.enc
rails credentials:edit
```
```yml
mysql:
  development:
    username: username
    password: password
discord:
  client_id: 123456789
  client_secret: abc123
```

#### Load the database
```
bin/rake db:schema:load
bin/rake data:initialize
```

#### Schedule jobs
Run `whenever` to schedule the application's cronjobs.

```
bundle exec whenever -s 'environment=INSERT_ENV_HERE' --update-crontab
```

Please note that if you did not install your Ruby using rbenv, you will need to change the bundle command located in `config/schedule.rb`

#### Start the server
```
rails server
```

#### Start the Sidekiq processes as needed for background sync jobs
```
bundle exec sidekiq -C config/sidekiq_character.yml
bundle exec sidekiq -C config/sidekiq_free_company.yml
```

## Docker
A containerized stack is provided as an alternative to the manual installation above. It brings up MariaDB, Redis, the Rails web app and both Sidekiq workers, and runs a one-shot `data-updater` service that clones/updates the `xiv-data` submodule and applies schema or data updates automatically on every `up`.

#### Files
* `Dockerfile` — multi-stage build with `dev` and `prod` targets.
* `docker-compose.yml` — development stack (`RAILS_ENV=development`, source bind-mounted into the container).
* `docker-compose.prod.yml` — production stack (`RAILS_ENV=production`, eager-loaded Rails, precompiled assets, Puma).
* `.env.example` — template for the runtime configuration.

#### Deploy folder convention
Compose is **not** invoked from inside the repo. Runtime config (`.env`, encrypted credentials) lives in a separate deploy folder outside the repo. The repo only holds the compose files.

Every compose command follows this shape (the `--env-file` flag is required — under Compose v2, `.env` is read from the compose file's directory by default, not cwd, when `-f` is used):

```
cd <deploy>
docker compose --env-file .env -f <repo>\docker-compose.yml <subcommand>
```

#### One-time setup
1. Create the Discord OAuth app and set up `config/credentials.yml.enc` as described in the [manual install](#create-the-necessary-3rd-party-applications). Move `config/credentials.yml.enc` and `config/master.key` into the deploy folder — the compose files mount `credentials.yml.enc` from there read-only, and `master.key` is exposed to the container as the `RAILS_MASTER_KEY` env var.
2. In the deploy folder, copy `.env.example` to `.env` and fill in `RAILS_MASTER_KEY`, the MariaDB credentials, and (for prod) `SECRET_KEY_BASE`.
3. Create the `ASSETS_DIR` / `CONFIG_DIR` paths referenced in `.env` (defaults are documented in `.env.example`). These hold the database, downloaded images, logs, and the encrypted credentials so they survive image rebuilds.

You do **not** need to initialize the `vendor/xiv-data` submodule manually. The `data-updater` service clones the `xiv-data` repo into `${ASSETS_DIR}/xiv-data` on first `up` and pulls new commits on every subsequent `up`. The Dockerfile deliberately does not bake the game data into the image.

#### Build and run (development)
```
cd <deploy>
docker compose --env-file .env -f <repo>\docker-compose.yml build
docker compose --env-file .env -f <repo>\docker-compose.yml up
```
The app is then available on `http://localhost:3000`. The first start loads the schema and runs `data:initialize`; subsequent starts only run `data:update` if the `xiv-data` submodule has new commits, otherwise the updater exits immediately.

#### Build and run (production)
```
cd <deploy>
docker compose --env-file .env -f <repo>\docker-compose.prod.yml build
docker compose --env-file .env -f <repo>\docker-compose.prod.yml up -d
```
Dev and prod share the same `ASSETS_DIR` / `CONFIG_DIR` mounts, so the database, downloaded assets and credentials carry over between the two modes.

#### Common one-off tasks
Run inside a transient container:
```
docker compose --env-file .env -f <repo>\docker-compose.yml run --rm web bin/rake db:schema:load
docker compose --env-file .env -f <repo>\docker-compose.yml run --rm web bin/rails console
```

#### Caveats
* No `whenever` cron container is included. Scheduled `cache:*` tasks (leaderboard rankings, prices, ownership) won't refresh on their own — run them manually via `docker compose run --rm web bin/rake cache:rankings:server` or schedule them on the host.
* On Windows hosts, CRLF line endings in `bin/*` and `docker/entrypoint.sh` are stripped at build time. If you add new shell scripts, make sure the Dockerfile's `sed -i 's/\r$//'` step covers them.

## Updating
When new data becomes available on patch day, it can be loaded into the database by running the `data:update` rake task.

```
git submodule update --remote
bin/rake data:update
bin/rake assets:precompile
# Restart the application
bin/rails console
[Achievement, Mount, Minion, Orchestrion, Emote, Barding, Hairstyle, Armoire, Outfit, Fashion, Facewear, Frame, Card, NPC].each { |model| count = model.where('created_at > ?', Date.current.beginning_of_day).update_all(patch: 'CURRENT PATCH'); puts "#{model}: #{count}" if count != 0 }
exit
```

This data is available once the [data repository](https://github.com/skyborn-industries/xiv-data) has been updated with the latest patch data.

More action may be required in the event of complex game updates. Patch data must be populated manually.

When using the Docker stack, the `data-updater` service performs the equivalent of the steps above automatically on every `compose up` — it detects new commits in `vendor/xiv-data`, runs `data:update`, and (in prod) re-runs `assets:precompile`. The patch-tagging console snippet still has to be applied manually after a major patch.

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
