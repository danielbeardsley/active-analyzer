require File.dirname(__FILE__) + '/../test_helper'
require 'lib/stats'

class StatTest < ActiveSupport::TestCase
  def test_stats
    def msg(method)
      "Stat.#{method} is incorrect"
    end
    
    stat = ActiveAnalyzer::Stat.new(30)
    stat.add(5)
    stat.add(6)
    stat.add(8)
    stat.add(9)
    assert 7==stat.median, "Median"
    assert 7==stat.average, "Average"
    assert_equal 4, stat.count, msg('count')
    assert_equal 5, stat.min, msg('min')
    assert_equal 9, stat.max, msg('max')
    assert_equal 28, stat.sum, msg('sum')
    assert_equal 158, (stat.standard_deviation*100).round, msg('standard_deviation')
  end
end
