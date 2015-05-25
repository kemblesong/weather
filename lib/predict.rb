require 'regression.rb'
require 'date'


class Predict

  # n = 0, prediction or most recent measurement?
  # wind dir is still string
  #ATTRIBUTES = [:current_temperature, :rainfall_since_9am, :wind_speed]
  ATTRIBUTES = ["temperature", "rainfall", "wind_speed", "wind_direction"]

  def self.predict observations, n  
    # create array of time relative to earliest time in observations plus 1 second, so that there will be no t=0
    # if t=0, cant regress logarithmically
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
    
    # TODO
    p "past_data #{past_data}"
    p "t_hash #{t_hash}"
  
    # hash of hashes, with 'n minutes from now' as key
    # hashes have weather attributes as key, and predicted value as value
    predictions = Hash.new
    
    # TODO
    #time_now_s = 600 + (observations[observations.size-1]["observed_at"] - observations[0]["observed_at"]).to_f
    relative_time_now = Time.now.to_i - observations[0]["observed_at"].to_f
    p "time now s #{relative_time_now}"
    
    ATTRIBUTES.each do |a|
      (0..n).step(10) do |t|
        predictions[t] ||= Hash.new
        if !past_data[a].nil?
          regression = Regression.new(t_hash[a], past_data[a])
          curr_eq = regression.get_equation_with_least_mse
          # TODO
          p ""
          p "attribute #{a}"
          p curr_eq
          p ""
          predictions[t][a] = curr_eq.calculate relative_time_now + n
        else
          # no recent readings
          predictions[t][a] = nil
        end
      end
    end
  
    puts predictions
  end
end