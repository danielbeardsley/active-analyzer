class EventLog < ActiveRecord::Base
  belongs_to :batch

  #Can Be Multiple Tables
  belongs_to :log_source, :polymorphic => true

  METRICS = [:total, :render, :db, :action]
  FUNCTIONS_TO_COLUMNS = {:total => 'total_time',
                         :mean => 'mean_time',
                         :min => 'min_time',
                         :max => 'max_time',
                         :count => 'event_count',
                         :std_dev => 'std_dev'}

  def self.get_historical_data_for(options)

    from = options[:from] || 2.weeks.ago
    to = options[:to] || Time.now
    from = from.beginning_of_day
    to = to.end_of_day
   
    metric = options[:metric] || :total
    function = options[:aggregate] || :total
    function = function.to_sym
    metric = metric.to_sym
    
    if METRICS.include? metric
      request = Request.first(:conditions => {
                                  :application_id => options[:application],
                                  :action => options[:action_name],
                                  :time_source => metric.to_s})
      raise "No Such Request record '#{options[:action_name]}' metric:#{metric}" if request.nil?
    else
      raise "Invalid metric, expected one of : #{METRICS.inspect}" 
    end

    if FUNCTIONS_TO_COLUMNS.has_key? function
      column = FUNCTIONS_TO_COLUMNS[function]
    else
      raise "Invalid aggregate function, expected one of : #{FUNCTIONS_TO_COLUMNS.keys.inspect}"
    end
    
    sql = <<EOQ
    SELECT unix_timestamp(batches.last_event) as time, event_logs.#{column}
    FROM event_logs
    INNER JOIN batches ON event_logs.batch_id = batches.id
              AND batches.first_event >= '#{from.to_formatted_s(:db)}'
              AND batches.first_event < '#{to.to_formatted_s(:db)}'
    WHERE event_logs.log_source_id = #{request.id}
          AND event_logs.log_source_type = 'Request'
    ORDER BY batches.first_event
EOQ

    EventLog.connection.select_rows(sql)
  end  
end
