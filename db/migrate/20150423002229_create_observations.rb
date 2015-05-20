class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.float :temperature
      t.float :dew_point
      t.float :rainfall
      t.string :wind_direction
      t.float :wind_speed
    end
  end
end
