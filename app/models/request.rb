class Request < ActiveRecord::Base
  has_many :event_logs, :as => :log_source
end
