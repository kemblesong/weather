class CreateTimeStamps < ActiveRecord::Migration
  def change
    create_table :time_stamps do |t|
      t.integer :timestamp
    end
  end
end
