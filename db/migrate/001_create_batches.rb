class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.datetime :first_event, :null => false
      t.datetime :last_event, :null => false
      t.integer  :line_count
      t.integer  :processing_time
      t.timestamps
    end
  end

  def self.down
    drop_table :batches
  end
end
