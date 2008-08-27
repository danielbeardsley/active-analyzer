class CreateEventLogs < ActiveRecord::Migration
  def self.up
    create_table :event_logs do |t|
      t.integer :batch_id, :null => false
      t.integer :log_source_id, :null => false
      t.string  :log_source_type, :null => false      
      t.integer :event_count
      t.float   :mean_time
      t.float   :max_time
      t.float   :min_time
      t.float   :median_time
      t.float   :std_dev
      t.float   :total_time
    end
  end

  def self.down
    drop_table :event_logs
  end
end
