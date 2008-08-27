class AddTimeSourceToRequests < ActiveRecord::Migration
  def self.up
    add_column :requests, :time_source, :integer, :null => false
    Request.connection.update("update requests set time_source = 0")
  end

  def self.down
    remove_column :requests, :time_source
  end
end
