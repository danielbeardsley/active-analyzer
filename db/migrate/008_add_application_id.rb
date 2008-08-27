class AddApplicationId < ActiveRecord::Migration
  def self.up
    add_column :templates, :application_id, :integer, :null => false
    add_column :requests, :application_id, :integer, :null => false
    
    %w{ templates requests }.each do |table|
      Request.connection.update("update #{table} set application_id = #{Application.find(:first).id}")
    end
  end

  def self.down
    remove_column :templates, :application_id
    remove_column :requests, :application_id
  end
end
