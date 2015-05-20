# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Location.create(name: 'melbourne-olympic-park', latitude: -37.83, longitude: 144.98)
Location.create(name: 'melbourne-airport', latitude: -37.67, longitude: 144.83)
Location.create(name: 'avalon', latitude: -38.03, longitude: 144.48)
Location.create(name: 'cerberus', latitude: -38.36, longitude: 145.18)
Location.create(name: 'coldstream', latitude: -37.72, longitude: 145.41)
Location.create(name: 'cranbourne', latitude: -38.13, longitude: 145.26)
Location.create(name: 'essendon-airport', latitude: -37.73, longitude: 144.91)
Location.create(name: 'fawkner-beacon', latitude: -37.91, longitude: 144.93)
Location.create(name: 'ferny-creek', latitude: -37.87, longitude: 145.35)
Location.create(name: 'frankston', latitude: -38.15, longitude: 145.12)
Location.create(name: 'geelong-racecourse', latitude: -38.17, longitude: 144.38)
Location.create(name: 'laverton', latitude: -37.86, longitude: 144.76)
Location.create(name: 'moorabbin-airport', latitude: -37.98, longitude: 145.10)
Location.create(name: 'phillip-island', latitude: -38.51, longitude: 145.15)
Location.create(name: 'point-wilson', latitude: -38.10, longitude: 144.54)
Location.create(name: 'rhyll', latitude: -38.46, longitude: 145.31)
Location.create(name: 'scoresby', latitude: -37.87, longitude: 145.26)
Location.create(name: 'sheoaks', latitude: -37.91, longitude: 144.13)
Location.create(name: 'south-channel-island', latitude: -38.31, longitude: 144.80)
Location.create(name: 'st-kilda-harbour-rmys', latitude: -37.86, longitude: 144.96)
Location.create(name: 'viewbank', latitude: -37.74, longitude: 145.10)

Source.create(name: 'the-beureu-of-meteorology', format: 'html')
Source.create(name: 'forecast-io', format: 'json')
