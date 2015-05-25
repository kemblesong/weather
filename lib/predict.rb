require 'regression.rb'
require 'date'


class Predict

  # n = 0, prediction or most recent measurement?
  # wind dir is still string
  #ATTRIBUTES = [:current_temperature, :rainfall_since_9am, :wind_speed]
  ATTRIBUTES = ["current_temperature", "rainfall_since_9am", "wind_speed"]

  def self.predict observations, n  
    # create array of time relative to earliest time in observations plus 1 second, so that there will be no t=0
    # if t=0, cant regress logarithmically
    t_array = Array.new
    observations.each{|o| t_array << 1 + (o["observation_time"] - observations[0]["observation_time"]).to_f}
    
    # each attribute should have its own time array
    # this is because we will remove time where its observation value is nil
    t_hash = Hash.new
  
    # hash with weather attributes as key, and array of past measurements as value
    past_data = Hash.new
    ATTRIBUTES.each do |a|
      observations.each_with_index do |o, i|
        # skip nil values
        if !o[a].nil?
          (past_data[a] ||= []) << o[a]
          (t_hash[a] ||= []) << t_array[i]
        end
      end
    end
    
    # TODO
    p "past_data #{past_data}"
    p "t_hash #{t_hash}"
  
    # hash of hashes, with 'n minutes from now' as key
    # hashes have weather attributes as key, and predicted value as value
    predictions = Hash.new
    
    # TODO
    time_now_s = 600 + (observations[observations.size-1]["observation_time"] - observations[0]["observation_time"]).to_f
    p "time now s #{time_now_s}"
    
    ATTRIBUTES.each do |a|
      (0..n).step(10) do |t|
        predictions[t] ||= Hash.new
        regression = Regression.new(t_hash[a], past_data[a])
        curr_eq = regression.get_equation_with_least_mse
        # TODO
        p ""
        p "attribute #{a}"
        p curr_eq
        p ""
        predictions[t][a] = curr_eq.calculate time_now_s + n
      end
    end
  
    puts predictions
  end
end