require File.dirname(__FILE__) + '/../test_helper'

class DefaultLogFormatTest < ActiveSupport::TestCase
  include(Mixins::DefaultLogFormat)
  P_LINE = 'Jul  1 06:28:47 rails ww_log[28524]: Processing MagicController#index (for 65.55.209.227 at 2008-07-01 06:28:46) [GET]'
  R_LINE = 'Dec 13 16:19:57 rails ww_log[28524]: Rendered shared/_account_links (0.00470)'
  C_LINE = 'Jun  1 25:21:28 rails ww_log[28524]: Completed in 0.27872 (3 reqs/sec) | Rendering: 0.08294 (29%) | DB: 0.16501 (59%) | 200 OK [http://wikiwalki.com/mytrails?page=1&sort=title&sort_direction=ASC]'
  L_LINE = 'Jul  1 06:28:47 rails ww_log[28524]: Tag Load (0.005425)   SELECT * FROM `tags`'  
  REPEAT_LINE = 'Jul  1 06:28:47 rails last message repeated 5 times'  
  
  def test_getProcessId
    assert_equal 28524, getProcessId(P_LINE), 'Process ID wasn\'t read correctly'
  end

  def test_processing_line
    assert_equal ({:type => :processing, :action => 'MagicController#index'}),
      getEventInfo(P_LINE), 'Processing line wasn\'t read correctly'
  end

  def test_rendered_line
    assert_equal ({:type => :rendered, :template => 'shared/_account_links', :time => 0.0047}),
      getEventInfo(R_LINE), 'Rendered line wasn\'t read correctly'
  end

  def test_completed_line
    assert_equal ({:type => :completed, :total => 0.27872, :db => 0.16501, :render => 0.08294}),
      getEventInfo(C_LINE), '"Completed in" line wasn\'t read correctly' 
  end
  
  def test_dbload_line
    assert_equal ({:type => :db_load, :time => 0.005425, :table => 'Tag'}),
      getEventInfo(L_LINE), 'DB Load line wasn\'t read correctly' 
  end
  
  def test_repeat_count_line
    assert_equal 5, getRepeatedCount(REPEAT_LINE), '"Last message repeated" count wasn\'t read correctly' 
  end
  
  def test_nil_line
    assert_equal nil, getTime(nil), "getTime(Nil) didn't return nil"
    assert_equal nil, getProcessId(nil), "getProcessId(Nil) didn't return nil"
    assert_equal nil, getEventInfo(nil), "getEventInfo(Nil) didn't return nil"         
  end
  
  def test_nonsense_lines
    assert_equal nil, getTime("dkjfldkjlsklf lksl fsdf asd f^24:2fsa: fadskjfjf"), "getTime(nonsense) didn't return nil"     
    assert_equal nil, getProcessId("dkjfldkjlsklf lksl fsdf asd f^24:2fsa: fadskjfjf"), "getProcessId(nonsense) didn't return nil"     
    assert_equal nil, getEventInfo("dkjfldkjlsklf lksl fsdf asd f^24:2fsa: fadskjfjf"), "getEventInfo(nonsense) didn't return nil"
  end
  
  def test_incomplete_lines
    assert_equal nil, getProcessId("Dec 13 16:19:57 rails ww_log["), "getProcessId(*incomplete processID line*) didn't return nil"
    assert_equal nil, getProcessId("Dec 13 16:19:57 rails other stuff"), "getProcessId(*incomplete time*) didn't return nil"
    assert_equal nil, getEventInfo('Jul  1 06:28:47 rails ww_log[28524]: Tag'), "getEventInfo(*incomplete DB load line*) didn't return nil"
    assert_equal nil, getEventInfo('Jun  1 25:21:28 rails ww_log[28524]: Completed in'), "getEventInfo(*incomplete 'Completed' line*) didn't return nil"
    assert_equal nil, getEventInfo('Jun  1 25:21:28 rails ww_log[28524]: Processing'), "getEventInfo(*incomplete 'Processing' line*) didn't return nil"    
  end

end
