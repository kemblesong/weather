#!/bin/bash

bundle install
rake db:reset
rails runner "Fetcher.new.fetch('the-beureu-of-meteorology')"
rails runner "Fetcher.new.fetch('forecast-io')"
whenever -w
rails s
