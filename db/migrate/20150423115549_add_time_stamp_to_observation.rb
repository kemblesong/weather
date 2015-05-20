class AddTimeStampToObservation < ActiveRecord::Migration
  def change
    add_reference :observations, :time_stamp, index: true, foreign_key: true
  end
end
