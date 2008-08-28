class AddTimeSourceToRequests < ActiveRecord::Migration
  def self.up
    add_column :requests, :time_source, :string, :limit=> 16, :null => false
    Request.connection.update("update requests set time_source = 'total'")
  end

  def self.down
    remove_column :requests, :time_source
  end
end
