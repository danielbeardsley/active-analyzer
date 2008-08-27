class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string :name
      t.timestamps
    end
    
    add_column(:batches, :application_id, :integer)
  end

  def self.down
    drop_table :applications
    remove_column(:batches, :application_id)
  end
end
