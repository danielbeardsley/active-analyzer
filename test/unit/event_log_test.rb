require File.dirname(__FILE__) + '/../test_helper'

class EventLogTest < ActiveSupport::TestCase
  should_belong_to :batch
  should_belong_to :log_source

  def get_first_number(options)
    EventLog.get_historical_data_for(options).first[1].to_f
  end
  
  context "EventLog.get_historical_data for requests" do
    setup do
      @options = {:application => 1, :action_name => 'Controller#action0', :from => 3.days.ago.beginning_of_day}
    end


    should "respect :from and :to date ranges" do 
      options_from = @options.merge({:from => 1.day.ago.beginning_of_day})
      options_to = @options.merge({:to => 1.day.ago.beginning_of_day})
      
      assert_equal 3, EventLog.get_historical_data_for(@options.except(:from)).length, 'default date range should be 2 weeks ago -> now'
      assert_equal 2, EventLog.get_historical_data_for(options_from).length, ':from didn''t work'
      assert_equal 2, EventLog.get_historical_data_for(options_to).length, ':to didn''t work'
    end
    
    
    should "respect :metric" do 
      options_total = @options.merge({:metric => :total})
      options_metric = @options.dup
      
      assert_equal 900, get_first_number(@options), 'default metric should be :total'
      assert_equal 900, get_first_number(options_total), 'default metric should be :total'
      
      (EventLog::METRICS - [:total]).each do |metric|
        options_metric[:metric] = metric
        assert_equal 450, get_first_number(options_metric), "metric #{metric} didn't work"
      end
    end    


    should "respect :aggregate" do 
      options_total = @options.merge({:aggregate => :total})
      options_aggregate = @options.dup
      
      assert_equal 900, get_first_number(@options), 'default metric should be :total'
      assert_equal 900, get_first_number(options_total), 'default metric should be :total'
      
      {:total => 900, :mean => 3, :min => 1.5,
       :max => 6, :count => 300, :std_dev => 1.5}.each do |agg, value|
        options_aggregate[:aggregate] = agg
        assert_equal value, get_first_number(options_aggregate), "aggregate #{agg} didn't work"
      end
    end 
  end
  
  context "EventLog.get_historical_data for templates" do
    setup do
      @options = {:application => 1, :template => 'template0', :from => 3.days.ago.beginning_of_day}
    end

    should "respect :from and :to date ranges" do 
      options_from = @options.merge({:from => 1.day.ago.beginning_of_day})
      options_to = @options.merge({:to => 1.day.ago.beginning_of_day})
      
      assert_equal 3, EventLog.get_historical_data_for(@options.except(:from)).length, 'default date range should be 2 weeks ago -> now'
      assert_equal 2, EventLog.get_historical_data_for(options_from).length, ':from didn''t work'
      assert_equal 2, EventLog.get_historical_data_for(options_to).length, ':to didn''t work'
    end
    
    should "respect :aggregate" do 
      options_total = @options.merge({:aggregate => :total})
      options_aggregate = @options.dup
      
      assert_equal 900, get_first_number(@options), 'default metric should be :total'
      assert_equal 900, get_first_number(options_total), 'default metric should be :total'
      
      {:total => 900, :mean => 3, :min => 1.5,
       :max => 6, :count => 300, :std_dev => 1.5}.each do |agg, value|
        options_aggregate[:aggregate] = agg
        assert_equal value, get_first_number(options_aggregate), "aggregate #{agg} didn't work"
      end
    end 
  end
end
