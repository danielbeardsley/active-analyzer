require File.dirname(__FILE__) + '/../test_helper'

class BatchTest < ActiveSupport::TestCase
  should_have_many :event_logs
  should_belong_to :application
  
  should 'calculate lines_per_second correctly' do
    b = Batch.first
    assert_equal b.line_count / (b.processing_time / 1000), b.lines_per_second, 'lines_per_second not correct'

    b.line_count = nil
    assert_equal 0, b.lines_per_second, 'lines_per_second should be 0 when line_count = nil'
    b.reload
    
    b.processing_time = 0
    assert_equal 0, b.lines_per_second, 'lines_per_second should be 0 when processing_time = 0'
    
    b.processing_time = nil
    assert_equal 0, b.lines_per_second, 'lines_per_second should be 0 when processing_time = nil'
  end  
end
