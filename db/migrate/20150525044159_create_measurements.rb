class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float :temperature
      t.float :rainfall
      t.float :wind_direction
      t.float :wind_speed
    end
  end
end
