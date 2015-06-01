require 'regression.rb'
require 'date'


class Predict

  # n = 0, prediction or most recent measurement?
  # wind dir is still string
  #ATTRIBUTES = [:current_temperature, :rainfall_since_9am, :wind_speed]
  ATTRIBUTES = %w(temperature rainfall wind_speed wind_direction)

  def self.regress(observations, n)
    # create array of time relative to earliest time in observations plus 1 second, so that there will be no t=0
    # if t=0, cant regress logarithmically
    if observations.nil?
      # does not have observations, return empty hash
      return Hash.new
    end

    t_array = Array.new
    first = observations[0]

    observations.each { |o| t_array << 1 + (o["observed_at"] - first["observed_at"]).to_f }

    # each attribute should have its own time array
    # this is because we will remove time where its observation value is nil
    t_hash = Hash.new

    # hash with weather attributes as key, and array of past measurements as value
    past_data = Hash.new
    ATTRIBUTES.each do |a|
      observations.each_with_index do |o, i|
        #observations.get_measurements.each_with_index do |o, i|
        # skip nil values
        measurement = o.get_measurement
        unless measurement[a].nil?
          (past_data[a] ||= []) << measurement[a]
          (t_hash[a] ||= []) << t_array[i]
        end
      end
    end

    # hash of hashes, with 'n minutes from now' as key
    # hashes have weather attributes as key, and predicted value as value
    predictions = Hash.new


    time_now = Time.now
    relative_time_now = time_now.to_i - observations[0]['observed_at'].to_f

    ATTRIBUTES.each do |a|
      (0..n).step(10) do |t|
        predictions[t] ||= Hash.new
        predictions[t]['time'] = (time_now + t*60).strftime('%I:%M%p %d-%m-%Y')
        predictions[t][a] = Hash.new
        if !past_data[a].nil? && past_data[a].size > 1
          # has at least 2 past measurements
          regression = Regression.new(t_hash[a], past_data[a])
          curr_eq, mse = regression.get_equation_with_least_mse
          predictions[t][a]['value'] = (curr_eq.calculate relative_time_now + t*60).round(1)
          predictions[t][a]['probability'] = (estimate_probability mse).round(2)
        else
          # no or only 1 past measurement
          predictions[t][a]['value'] = nil
          predictions[t][a]['probability'] = nil
        end
      end
    end

    predictions.each do |t, prediction|
      unless predictions[t]['wind_direction']['value'].nil?
        # convert to cardinal
        predictions[t]['wind_direction']['value'] = Cardinal.from_degree predictions[t]['wind_direction']['value']
      end
      unless predictions[t]['rainfall']['value'].nil?
        # add mm unit
        predictions[t]['rainfall']['value'] = "#{predictions[t]['rainfall']['value']}mm"
      end
    end

    return predictions
  end

  # estimate the probability from a mean squared error
  def self.estimate_probability(mse)
    weight = 2000
    prob = 1 - mse/weight

    if prob < 0.1
      # we set smallest value for probability as 0.1
      prob = 0.1
    end

    return prob
  end

  def self.get_current_cond(location)
    if !self.has_reading_last_30m location
      # no measurements available from the past 30mins
      return nil
    end

    # get the latest measurement
    latest_m = Observation.where(location: location).last.get_measurement

    # estimate weather condition
    if latest_m.rainfall > 0
      return 'raining'
    elsif latest_m.wind_speed > 18
      return 'windy'
    elsif latest_m.temperature > 20
      return 'sunny'
    else
      return 'cloudy'
    end
  end

  def self.get_current_temp(location)
    if !self.has_reading_last_30m location
      # no measurements available from the past 30mins
      return nil
    end

    # return latest temperature reading
    return Observation.where(location_id: location.id).last.get_measurement.temperature
  end

  def self.has_reading_last_30m(location)
    # when was the last time location has its reading updated
    last_updated = Observation.where(location_id: location.id).order(observed_at: :desc).first.observed_at
    if Time.now.to_i - last_updated > 30*60
      # no measurements available from the past 30mins
      return false
    end
    return true
  end
end
