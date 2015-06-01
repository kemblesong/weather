class Observation < ActiveRecord::Base
  belongs_to :location
  has_one :measurement

  def get_measurement
    Measurement.find(self.measurement_id)
  end

end