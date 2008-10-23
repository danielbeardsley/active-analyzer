module RequestsHelper
  def total_requests_column(request)
    request.event_logs.sum(:event_count)
  end
end
