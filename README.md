# FFXIV Collect
This is another application for tracking your Final Fantasy XIV collections written in [Ruby on Rails](https://rubyonrails.org/). Game data is powered by [Saint Coinach](https://github.com/ufx/SaintCoinach). This application strives to be as autonomous as possible by pulling as much data as possible from [Saint Coinach](https://github.com/ufx/SaintCoinach). The rest is maintained by myself and a small group of moderators using community-sourced data.

## API

All of this application's data is made available through a RESTful JSON API. See the [documentation](https://ffxivcollect.com/api/docs) for details.

## Dependencies
* Ruby (2.4.1)
* Rails (5.2)
* MySQL
* Redis

## Installation
#### Clone and initialize the repository
```
git clone https://github.com/mattantonelli/ffxiv-collect
cd ffxiv-collect
bundle install
bundle exec rake app:update:bin
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

#### Extract the images & music samples
Extract images & music samples from the game data by following the instructions in the [data repository](https://github.com/mattantonelli/xiv-data).

#### Load the database
```
bundle exec rake db:schema:load
bundle exec rake data:initialize
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

## Updating
When new data becomes available on patch day, it can be loaded into the database by running the `data:update` rake task.

```
bundle exec rake data:update
bundle exec rake assets:precompile
# Restart the application
bundle exec rails console
[Achievement, Mount, Minion, Orchestrion, Emote, Barding, Hairstyle, Armoire, Fashion].each { |model| puts "#{model}: #{model.where('created_at > ?', Date.current.beginning_of_day).update_all(patch: 'CURRENT PATCH')}" }
exit
```

This data is available once the [data repository](https://github.com/mattantonelli/xiv-data) has been updated with the latest patch data.

More action may be required in the event of complex game updates. Patch data must be populated manually.

### Images
Images must be extracted from the game data. Click [here](https://github.com/mattantonelli/xiv-data#images) for details.

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
