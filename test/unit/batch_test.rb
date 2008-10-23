require File.dirname(__FILE__) + '/../test_helper'

class BatchTest < ActiveSupport::TestCase
  def test_associations
    b = Batch.find(2)
    
    assert_equal 18, b.event_logs.count, 'Batch.event_logs didn''t return the correct number of records'
    assert_not_nil b.event_logs.find(262), 'Batch.event_logs didn''t return a record it should have'
    assert_equal Application.find(2), b.application, 'Batch.application'
    
  end
  
  def test_methods
    b = Batch.find(2)
    assert_equal 9103, b.lines_per_second, 'lines_per_second not correct'

    b.line_count = nil
    assert_equal 0, b.lines_per_second, 'lines_per_second should be 0 when line_count = nil'
    b.reload
    
    b.processing_time = 0
    assert_equal 0, b.lines_per_second, 'lines_per_second should be 0 when processing_time = 0'
    
    b.processing_time = nil
    assert_equal 0, b.lines_per_second, 'lines_per_second should be 0 when processing_time = nil'
    
  end  
end
