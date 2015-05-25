class AddMeasurementToObservation < ActiveRecord::Migration
  def change
    add_reference :observations, :measurement, index: true, foreign_key: true
  end
end
