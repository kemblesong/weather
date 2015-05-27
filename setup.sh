#!/bin/bash

bundle install
rails runner "Fetcher.new.fetch"
whenever -w
rails s
