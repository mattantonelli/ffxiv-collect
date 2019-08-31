#!/bin/bash
echo Start ffxiv-collect
sleep 20s
bundle exec rake db:schema:load
bundle exec rake data:initialize
rails server -b 0.0.0.0
bundle exec sidekiq