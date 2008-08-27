class EventLog < ActiveRecord::Base
  belongs_to :batch

  #Can Be Multiple Tables
  belongs_to :log_source, :polymorphic => true
  
end
