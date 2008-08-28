# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

  create_table "applications", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.datetime "first_event",     :null => false
    t.datetime "last_event",      :null => false
    t.integer  "line_count"
    t.integer  "processing_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "application_id"
  end

  create_table "event_logs", :force => true do |t|
    t.integer "batch_id",                        :null => false
    t.integer "log_source_id",                   :null => false
    t.string  "log_source_type", :default => "", :null => false
    t.integer "event_count"
    t.float   "mean_time"
    t.float   "max_time"
    t.float   "min_time"
    t.float   "median_time"
    t.float   "std_dev"
    t.float   "total_time"
  end

  create_table "requests", :force => true do |t|
    t.string   "action"
    t.datetime "first_event"
    t.datetime "most_recent_event"
    t.integer  "application_id",                                  :null => false
    t.string   "time_source",       :limit => 16, :default => "", :null => false
  end

  create_table "templates", :force => true do |t|
    t.string   "path"
    t.datetime "first_event"
    t.datetime "most_recent_event"
    t.integer  "application_id",    :null => false
  end

end
