#!/bin/bash

bundle install
rake db:migrate
rails runner "Fetcher.new.fetch"
whenever -w
rails s
