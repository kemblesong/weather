require 'regression.rb'
require 'date'


class Predict

  # n = 0, prediction or most recent measurement?
  # wind dir is still string
  #ATTRIBUTES = [:current_temperature, :rainfall_since_9am, :wind_speed]
  ATTRIBUTES = ["temperature", "rainfall", "wind_speed", "wind_direction"]

  def self.regress observations, n  
    # create array of time relative to earliest time in observations plus 1 second, so that there will be no t=0
    # if t=0, cant regress logarithmically
    if observations.nil?
      # does not have observations, return empty hash
      return Hash.new
    end
    
    t_array = Array.new
    first = observations[0]

    observations.each{|o| t_array << 1 + (o["observed_at"] - first["observed_at"]).to_f}
    
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
        if !measurement[a].nil?
          (past_data[a] ||= []) << measurement[a]
          (t_hash[a] ||= []) << t_array[i]
        end
      end
    end
  
    # hash of hashes, with 'n minutes from now' as key
    # hashes have weather attributes as key, and predicted value as value
    predictions = Hash.new
    

    time_now = Time.now
    relative_time_now = time_now.to_i - observations[0]["observed_at"].to_f
    p "time now s #{relative_time_now}"
    
    ATTRIBUTES.each do |a|
      (0..n).step(10) do |t|
        predictions[t] ||= Hash.new
        predictions[t]["time"] = time_now + t*60
        predictions[t][a] = Hash.new
        if !past_data[a].nil? && past_data[a].size > 1
          # has at least 2 past measurements
          regression = Regression.new(t_hash[a], past_data[a])
          curr_eq, mse = regression.get_equation_with_least_mse
          predictions[t][a]["value"] = curr_eq.calculate relative_time_now + t*60
          predictions[t][a]["probability"] = estimate_probability mse
        #TODO nil if only have 1 data?
        elsif past_data[a].size == 1
          # only has 1 past measurement, use that 1 measurement
          # we approximate probability to 0.8
          predictions[t][a]["value"] = past_data[a][0]
          predictions[t][a]["probability"] = 0.8
        else
          # no past measurement
          predictions[t][a]["value"] = nil
          predictions[t][a]["probability"] = nil
        end
      end
    end
    
    puts predictions
    
    #TODO rain mm
    predictions.each do |t, prediction|
      if !predictions[t]["wind_direction"]["value"].nil?
        predictions[t]["wind_direction"]["value"] = Cardinal.from_degree predictions[t]["wind_direction"]["value"]
      end
    end
    
    return predictions
  end
  
  # estimate the probability from a mean squared error
  def self.estimate_probability mse
    weight = 2000
    prob = 1 - mse/weight
    
    if prob < 0.1
      # we set smallest value for probability as 0.1
      prob = 0.1
    end
    
    return prob
  end
end