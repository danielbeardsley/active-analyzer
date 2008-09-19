require File.dirname(__FILE__) + '/../test_helper'
require 'stringio'

class ProcessorTest < ActiveSupport::TestCase
  
  def test_log_with_repeat
    log = <<R_LOG
Jul  1 06:28:47 rails ww_log[28524]: Rendered /shared/_tags_js.html.erb (0.01165)
Jul  1 06:28:47 rails ww_log[28524]: Rendered mytemplate/_list_column_headings (0.02666)
Jul  1 06:28:47 rails last messaged repeated 15 times
R_LOG
    p = Processor.new(applications(:one))
    p.consume_file(StringIO.new(log))
    temp_id = Template.find_by_path('mytemplate/_list_column_headings').id
    e = EventLog.find_by_log_source_id(temp_id)
    assert_equal 16, e.event_count, "Repeated Line Count is wrong"
    assert_equal 0.42656, e.total_time, "Repeated Line total_time is wrong"

    temp_id = Template.find_by_path('/shared/_tags_js.html.erb').id
    e = EventLog.find_by_log_source_id(temp_id)
    assert_equal 1, e.event_count, "Single Line Count is wrong"
    assert_equal 0.01165, e.total_time, "Single Line total_time is wrong"
  end

  def test_dual_process_log
    log = <<R_LOG
Jul  1 06:28:47 rails ww_log[28524]: Processing MyController#index (for 65.55.209.227 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[28520]: Processing MyController#list (for 65.55.209.220 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[58521]: Processing MyController#list (for 65.55.209.220 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[28524]: SQL (0.3)   SELECT count(*) AS count_all FROM `records` WHERE id ='lksdlkslk8f' 
Jul  1 06:28:47 rails ww_log[28520]: SQL (0.1)   SELECT count(*) AS count_all FROM `records` WHERE id ='lksdlkslk8f' 
Jul  1 06:28:47 rails ww_log[58521]: Completed in 9.0 (3 reqs/sec) | Rendering: 1.0 (29%) | DB: 1.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
Jul  1 06:28:47 rails ww_log[28524]: Record Load (3.0)   SELECT * FROM `records` WHERE id = 'EquRgwbTcKUX7WId'
Jul  1 06:28:47 rails ww_log[28520]: Record Load (1.0)   SELECT * FROM `records` WHERE id = 'EquRgwbTcKUX7WId'
Jul  1 06:28:47 rails ww_log[28524]: Rendered shared/_top (30.0)
Jul  1 06:28:47 rails ww_log[28520]: Rendered shared/_top (10.0)
Jul  1 06:28:47 rails ww_log[28524]: Completed in 3.0 (3 reqs/sec) | Rendering: 1.25 (29%) | DB: 1.25 (59%) | 200 OK [http://samplelog.com/mytemplate]
Jul  1 06:28:47 rails ww_log[28520]: Completed in 1.0 (3 reqs/sec) | Rendering: 1.0 (29%) | DB: 1.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
R_LOG
    p = Processor.new(applications(:one))
    p.consume_file(StringIO.new(log))

    temp_id = Request.find_by_action_and_time_source('MyController#index', 'total').id
    e = EventLog.find_by_log_source_id(temp_id)
    assert_equal 1, e.event_count, "Multiprocess event_count is wrong"
    assert_equal 3.0, e.total_time, "Multiprocess total_time is wrong"

    temp_id = Request.find_by_action_and_time_source('MyController#list', 'total').id
    e = EventLog.find_by_log_source_id(temp_id)
    assert_equal 2, e.event_count, "Multiprocess event_count is wrong"
    assert_equal 10, e.total_time, "Multiprocess total_time is wrong"
  end
  
  def test_total_db_render_times
    log = <<R_LOG
Jul  1 06:28:47 rails ww_log[28524]: Processing MyController#index (for 65.55.209.227 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[28520]: Processing MyController#list (for 65.55.209.220 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[58521]: Processing MyController#list (for 65.55.209.220 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[58521]: Completed in 9.0 (3 reqs/sec) | Rendering: 1.0 (29%) | DB: 1.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
Jul  1 06:28:47 rails ww_log[28524]: Completed in 3.0 (3 reqs/sec) | Rendering: 1.25 (29%) | DB: 1.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
Jul  1 06:28:47 rails ww_log[28520]: Completed in 3.0 (3 reqs/sec) | Rendering: 1.0 (29%) | DB: 2.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
R_LOG
    p = Processor.new(applications(:one))
    p.consume_file(StringIO.new(log))

    {:index => {:total => 3, :db => 1.0, :render => 1.25, :action => 0.75},
     :list => {:total => 12, :db => 3, :render => 2, :action => 7}}.each do |action, time_source_hash|
      time_source_hash.each do |time_source, expected|
        puts "Testing action:" + 'MyController#' + action.to_s + " and time_source:#{time_source}"
        el = Request.find_by_action_and_time_source('MyController#' + action.to_s, time_source.to_s).event_logs[0]
        assert_equal expected, el.total_time, "Multiprocess total_time is wrong for time_source:#{time_source}"
      end
    end

    temp_id = Request.find_by_action_and_time_source('MyController#list', 'total').id
    e = EventLog.find_by_log_source_id(temp_id)
    assert_equal 2, e.event_count, "Multiprocess event_count is wrong"
  end
  
  def test_first_last_event
    log = <<R_LOG
Jul  1 06:28:47 rails ww_log[28524]: Processing MyController#index (for 65.55.209.227 at 2008-07-01 06:28:46) [GET]
Jul  2 06:28:47 rails ww_log[28520]: Processing MyController#list (for 65.55.209.220 at 2008-07-01 06:28:46) [GET]
Jul  1 07:28:47 rails ww_log[58521]: Processing MyController#list (for 65.55.209.220 at 2008-07-01 06:28:46) [GET]
Jul  1 07:28:47 rails ww_log[58521]: Completed in 9.0 (3 reqs/sec) | Rendering: 1.0 (29%) | DB: 1.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
Jul  1 06:28:47 rails ww_log[28524]: Rendered shared/_top (30.0)
Jul  2 06:28:47 rails ww_log[28520]: Rendered shared/_top (10.0)
Jul  1 06:28:47 rails ww_log[28524]: Completed in 3.0 (3 reqs/sec) | Rendering: 3.0 (29%) | DB: 3.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
Jul  2 06:28:47 rails ww_log[28520]: Completed in 1.0 (3 reqs/sec) | Rendering: 1.0 (29%) | DB: 1.0 (59%) | 200 OK [http://samplelog.com/mytemplate]
R_LOG
    p = Processor.new(applications(:one))
    p.consume_file(StringIO.new(log))
    r = Request.find_by_action('MyController#index')
    assert_equal 'Tue Jul 01 06:28:47 -0700 2008', r.first_event.to_s, "first_event is wrong"
    assert_equal 'Tue Jul 01 06:28:47 -0700 2008', r.most_recent_event.to_s, "most_recent_event is wrong"

    r = Request.find_by_action('MyController#list')
    assert_equal 'Tue Jul 01 07:28:47 -0700 2008', r.first_event.to_s, "first_event is wrong"
    assert_equal 'Wed Jul 02 06:28:47 -0700 2008', r.most_recent_event.to_s, "most_recent_event is wrong"

log.gsub!('Jul ', 'Jan ')

    p.consume_file(StringIO.new(log))
    puts "======  After date change====="
   
    r = Request.find_by_action('MyController#index')
    assert_equal 'Tue Jan 01 06:28:47 -0800 2008', r.first_event.to_s, "first_event is wrong"
    assert_equal 'Tue Jul 01 06:28:47 -0700 2008', r.most_recent_event.to_s, "most_recent_event is wrong"

    r = Request.find_by_action('MyController#list')
    assert_equal 'Tue Jan 01 07:28:47 -0800 2008', r.first_event.to_s, "first_event is wrong"
    assert_equal 'Wed Jul 02 06:28:47 -0700 2008', r.most_recent_event.to_s, "most_recent_event is wrong"
    
log.gsub!('Jan ', 'Aug ')

    p.consume_file(StringIO.new(log))
    r = Request.find_by_action('MyController#index')
    assert_equal 'Tue Jan 01 06:28:47 -0800 2008', r.first_event.to_s, "first_event is wrong"
    assert_equal 'Fri Aug 01 06:28:47 -0700 2008', r.most_recent_event.to_s, "most_recent_event is wrong"

    r = Request.find_by_action('MyController#list')
    assert_equal 'Tue Jan 01 07:28:47 -0800 2008', r.first_event.to_s, "first_event is wrong"
    assert_equal 'Sat Aug 02 06:28:47 -0700 2008', r.most_recent_event.to_s, "most_recent_event is wrong"

  end  
  
  def test_minimal_log
    p = Processor.new(applications(:one))
    #p.consume_file(File.new(File.dirname(__FILE__) + '/../mocks/test/minimal.log'))
    #print_models
  end

  def test_duplicate_batch
    p = Processor.new(applications(:one))
    p.consume_file(File.new(File.dirname(__FILE__) + '/../mocks/test/minimal.log'))
    assert_raise RuntimeError do
      p.consume_file(File.new(File.dirname(__FILE__) + '/../mocks/test/minimal.log'))
    end
    #print_models
  end

  def test_full_log
puts Benchmark.measure {
    p = Processor.new(applications(:one))
    #p.consume_file(File.new(File.dirname(__FILE__) + '/../mocks/test/production.log'))
}
    #print_models
  end

  def test_slimtimer_log
puts Benchmark.measure {    
    p = Processor.new(applications(:one))
    #p.consume_file(File.new(File.dirname(__FILE__) + '/../mocks/test/slimtimer.log'))
 }
#    print_models
  end

  def test_huge_log
puts Benchmark.measure {    
    p = Processor.new(applications(:one))
    #p.consume_file(File.new(File.dirname(__FILE__) + '/../../../slimtimer.log.0'))
 }
# print_models
  end
  
  def print_models
    [Batch, Request, Template, EventLog].each{|model|
      model.find(:all).each do |rec| puts rec.inspect end
    }    
  end
end
