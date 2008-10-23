require File.dirname(__FILE__) + '/../test_helper'

class TemplateTest < ActiveSupport::TestCase
  def test_associations
    r = Template.find(53)
    assert_equal 7, r.event_logs.count, 'Template.event_logs isn''t returning all the records'
    assert_not_nil r.event_logs.find(293), 'Template.event_logs isn''t returning a record it should'
    assert_equal 'Template', r.event_logs.first.log_source_type,  'Template.event_logs is returning a record where log_source_type != Template'
  end
end
