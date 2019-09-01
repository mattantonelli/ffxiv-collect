#!/bin/bash
echo Start ffxiv-collect
rails server -b 0.0.0.0
bundle exec sidekiq