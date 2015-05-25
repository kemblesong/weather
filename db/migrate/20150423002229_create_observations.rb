class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.integer :observed_at
    end
  end
end
