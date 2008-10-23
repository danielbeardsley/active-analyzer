require File.dirname(__FILE__) + '/../test_helper'

class EventLogTest < ActiveSupport::TestCase
  def test_associations
    e = EventLog.find(262)
    assert_equal Batch.find(2), e.batch, 'EventLog.batch'
    assert_equal Request.find(215), e.log_source, 'EventLog.log_source (Request)'    
    assert_equal Template.find(53), EventLog.find(293).log_source, 'EventLog.log_source (Template)'        
  end
end
