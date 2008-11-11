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

  def self.get_historical_data_for(options = {})

    from = options[:from] || 8.weeks.ago
    to = options[:to] || Time.now
    from = from.beginning_of_day
    to = to.end_of_day
   
    log_source_name = options[:action_name] ? :request : :template
    log_source_class = log_source_name.to_s.camelize.constantize
    metric = (options[:metric] || :total).to_sym
    function = (options[:aggregate] || :total).to_sym
    
    conditions = {:application_id => options[:application]}
      
    case log_source_name
      when :request  then
        conditions.merge! :action => options[:action_name], :time_source => metric.to_s
      when :template then
        conditions[:path] = options[:template]
    end
    
    raise 'An action name or template path must be specified' if !conditions[:action] && !conditions[:path]
    raise "Invalid metric, expected one of : #{METRICS.inspect}" if !METRICS.include? metric
    
    log_source = log_source_class.first(:conditions => conditions)
    
    if log_source.nil?
      case log_source_name
        when :request  then raise "No Such Request record '#{options[:action_name]}' for metric:#{metric}"
        when :template then raise "No Such Template record '#{options[:template]}'"
      end
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
    WHERE event_logs.log_source_id = #{log_source.id}
          AND event_logs.log_source_type = '#{log_source_class}'
    ORDER BY batches.first_event
EOQ

    EventLog.connection.select_rows(sql)
  end  
end
