#!/bin/bash
bundle exec rake db:schema:load
bundle exec rake data:initialize