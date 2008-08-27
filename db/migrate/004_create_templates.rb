class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :path
      t.datetime :first_event
      t.datetime :most_recent_event      
    end
  end

  def self.down
    drop_table :templates
  end
end
