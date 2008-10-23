module TemplatesHelper
  def most_recent_event_column(record)
    record.most_recent_event.to_date
  end
  
  def total_renders_column(request)
    request.event_logs.sum(:event_count)
  end  
end
