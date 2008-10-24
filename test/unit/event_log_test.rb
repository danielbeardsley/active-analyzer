require File.dirname(__FILE__) + '/../test_helper'

class EventLogTest < ActiveSupport::TestCase
  should_belong_to :batch
  should_belong_to :log_source

  context "EventLog.get_log_" do
    setup do
    end
    
    should "test_get_graph_data_for" do 
      #base_options = {:action => 'AccountController#login', :from => 8.weeks.ago}
      #EventLog.get_graph_data_for(:action => 'AccountController#login', :from => 8.weeks.ago)
    end
    
    def test_data_for_metrics
  
    end
    
    def test_data_for_date_range

    end
  end
end
