class AddMeasurementToObservation < ActiveRecord::Migration
  def change
    add_reference :observation, :measurement, index: true, foreign_key: true
  end
end
