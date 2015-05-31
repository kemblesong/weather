# Weather
**SWEN30006: Software Modeling & Design - Project 3**  
A weather prediction and data scraping app built with Rails  
**Authors:** Group 22 - **Mingyou Fang** (678731), **Stephen Tjandra** (614604), **Kemble Song** (584999)

## Setup Instructions
Run the bash script `./setup.sh` from this directory.

## How to Use
#### For a list of locations:
http://localhost:3000/weather/locations
#### To query the database:
http://localhost:3000/weather/data/:location_id/:date  
http://localhost:3000/weather/data/:postcode/:date  
* `:location_id` is a name of a location in Victoria
* `:date` is a date specified in the format DD-MM-YYYY
* `:postcode` is a number between 3000-3999

#### For weather prediction:
http://localhost:3000/weather/predicition/:postcode/:period  
http://localhost:3000/weather/predicition/:lat/:long/:period  
* `:lat` is the latitude
* `:lon` is the longitude
* `:period` period is one of {10,30,60,120,180} and is a measure of time in minutes from the current time
