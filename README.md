# FFXIV Collect
This is another application for tracking your Final Fantasy XIV collections written in [Ruby on Rails](https://rubyonrails.org/) and powered by [XIVAPI](https://xivapi.com/). This application strives to be as autonomous as possible by pulling as much data as possible from [XIVAPI](https://xivapi.com/). The rest is maintained by a small group of moderators using community-sourced data.

## API

All of this application's data is made available through a RESTful JSON API. See the [wiki](https://github.com/mattantonelli/ffxiv-collect/wiki) for details.

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
1. Create a new [Discord app](https://discordapp.com/developers/applications/) for user authentication. Take note of the **client ID** and **secret**.
    1. Set the redirect URI on the OAuth2 page of your app: `http://localhost:3000/users/auth/discord/callback`
2. Create an [XIVAPI](https://xivapi.com/) account and take note of your API key.
3. Configure the credentials file to match the format below using your data.
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
xivapi_key: def456
google_analytics:
  tracking_id: GA-1234567-8
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

## Updating
When new data becomes available on patch day, it can be loaded into the database by running the `data:update` rake task.

```
bundle exec rake data:update
```

More action may be required in the event of complex game updates. Patch data must be populated manually.

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
