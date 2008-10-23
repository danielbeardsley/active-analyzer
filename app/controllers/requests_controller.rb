class RequestsController < BaseController
  active_scaffold :request do |config|
    config.columns = [:action, :most_recent_event, :total_requests]
    
    config.list.sorting = {:action => :asc}
    config.list.per_page = 6
    
    config.label = nil

    config.actions = [:list]
  end
  

protected

  def joins_for_collection
    [:event_logs]
  end
  
  def group_by_for_collection
    'event_logs.log_source_id'
  end
end
