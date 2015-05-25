class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :predicted_at
      t.integer :time_since_query
      t.float :rainfall_prob
      t.float :temp_prob
      t.float :wind_dir_prob
      t.float :wind_speed_prob
    end
  end
end
