class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.string :action
      t.datetime :first_event
      t.datetime :most_recent_event      
    end
  end

  def self.down
    drop_table :requests
  end
end
