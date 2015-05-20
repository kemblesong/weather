class AddSourceToObservation < ActiveRecord::Migration
  def change
    add_reference :observations, :source, index: true, foreign_key: true
  end
end
