class EventLogsController < BaseController
  def list
    @event_logs = EventLog.find(:all, :conditions => {:batch_id => params[:batch], :log_source_type => params[:type]})
  
    respond_to do |wants|
      wants.html { render :xml => @event_logs.to_xml }
      wants.xml { render :xml => @event_logs.to_xml }
    end
  end
end
