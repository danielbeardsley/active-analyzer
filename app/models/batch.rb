class Batch < ActiveRecord::Base
  has_many :event_logs
  belongs_to :application
end
