class TemplatesController < BaseController
  active_scaffold :template do |config|
    config.columns = [:path, :most_recent_event, :total_renders]
    
    config.list.sorting = {:path => :asc}
    config.list.per_page = 6
    
    config.label = nil

    config.actions = [:list]
  end
end
