class BatchesController < BaseController
  active_scaffold :batch do |config|
    config.columns = [:first_event, :last_event, :line_count, :processing_time, :lines_per_second]
    
    config.list.sorting = {:name => :asc}
    config.list.per_page = 6

    config.actions = [:list]
  end
end
