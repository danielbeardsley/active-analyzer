require File.dirname(__FILE__) + '/../test_helper'

class RequestTest < ActiveSupport::TestCase
  def test_associations
    r = Request.find(213)
    assert_equal 7, r.event_logs.count, 'Request.event_logs isn''t returning all the records'
    assert_not_nil r.event_logs.find(264), 'Request.event_logs isn''t returning a record it should'
    assert_equal 'Request', r.event_logs.first.log_source_type,  'Request.event_logs is returning a record where log_source_type != Request'    
  end
end
