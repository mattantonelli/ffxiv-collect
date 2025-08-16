# FFXIV Collect
This is a collection tracking companion website for Final Fantasy XIV collections written in [Ruby on Rails](https://rubyonrails.org/). Game data is powered by [XIVData Oxidizer](https://github.com/mattantonelli/xiv-data-oxidizer). This application strives to be as autonomous as possible by pulling most of its information directly from the game data. The rest is maintained by myself and a small group of moderators using community-sourced data.

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
git clone --recurse-submodules https://github.com/mattantonelli/ffxiv-collect
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
git submodule update --remote
bundle exec rake data:update
bundle exec rake assets:precompile
# Restart the application
bundle exec rails console
[Achievement, Mount, Minion, Orchestrion, Emote, Barding, Hairstyle, Armoire, Outfit, Fashion, Facewear, Frame, Card, NPC].each { |model| count = model.where('created_at > ?', Date.current.beginning_of_day).update_all(patch: 'CURRENT PATCH'); puts "#{model}: #{count}" if count != 0 }
exit
```

This data is available once the [data repository](https://github.com/mattantonelli/xiv-data) has been updated with the latest patch data.

More action may be required in the event of complex game updates. Patch data must be populated manually.

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
