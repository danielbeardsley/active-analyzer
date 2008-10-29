class EventLogsController < BaseController
  def list
    @event_logs = EventLog.get_historical_data_for(params)
    render :partial => 'json'
    return
    
    #Not until I see what the output format is
    respond_to do |wants|
      wants.html { render :xml => @event_logs.to_xml }
      wants.xml { render :xml => @event_logs.to_xml }
      wants.json { render :partial => 'json' }
    end
  end
end
