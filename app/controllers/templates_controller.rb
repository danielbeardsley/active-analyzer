class TemplatesController < BaseController
  active_scaffold :template do |config|
    config.columns = [:path, :total_renders, :total_time]
    
    config.list.sorting = {:total_time => :desc}
    config.list.per_page = 6
    
    config.label = nil

    config.actions = [:list]
  end
  

  def group_by_for_collection
    'event_logs.log_source_id'
  end
  
  def active_scaffold_finder_sql(options)
    order = options[:order]
    sql = "
    SELECT templates.*, SUM(event_logs.event_count) as total_renders, SUM(event_logs.total_time) as total_time
    FROM templates
    INNER JOIN event_logs ON templates.id = event_logs.log_source_id AND event_logs.log_source_type = 'Template'
    INNER JOIN batches ON event_logs.batch_id = batches.id
    WHERE batches.first_event > Date('#{18.weeks.ago.to_date}')
    GROUP BY event_logs.log_source_id
    #{order ? 'ORDER BY ' + order : nil }"
    ActiveRecord::Base.connection.add_limit_offset!(sql, options)
  end  
end
