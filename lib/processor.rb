class Processor
  include Mixins::DefaultLogFormat
  
  def initialize(application)
    @app = application
  end
  
  def consume_file(input_stream)
    @input = input_stream
    
    create_batch_record

puts "File Processed: " + (Benchmark.measure {
    build_stats
}).to_s
    create_request_records
    create_render_records
    
    @batch.save!
    @batch
  end

protected
  
  def create_batch_record
    @batch = Batch.new
    @batch.application = @app
  end
  
  def build_stats
    start_time = Time.now
    @request_total = StatHash.new    
    @request_db = StatHash.new
    @request_render = StatHash.new    
    @request_action = StatHash.new
    @render_stats = StatHash.new      
    last_actions = Hash.new
    line_count = 0
    first_line = last_line = nil
begin
    while line = @input.gets

      repeats = getRepeatedCount(line)
      if repeats == 0
        pid = getProcessId(line)
        info = getEventInfo(line)
        repeats = 1
      else
        line = last_line
      end
      
      if info.nil? || pid.nil?
        next
      end

      first_line = line if not first_line
      last_line = line       

      repeats.times do
        case info[:type]
          when :processing
            last_actions[pid] = info[:action]
          
          when :completed
            action = last_actions[pid]
            if not action.nil?
              @request_total.add(action, info[:total], line)
              @request_render.add(action, info[:render], line)
              @request_db.add(action, info[:db], line)
              @request_action.add(action, info[:total] - (info[:db] + info[:render]), line)
            end
          when :rendered
            @render_stats.add(info[:template], info[:time], line)
          
          else
        end

        line_count += 1
      end
      
      puts "lines: #{line_count} bytes:#{(@input.pos / 1024).ceil}KB" if(line_count % 2000) == 0
      
      last_line = line
    end
  rescue  Exception => e   
    puts "Error at line#:#{line_count}  line:#{line}"
    raise e
  end    
    @batch.first_event = getTime(first_line)
    @batch.last_event = getTime(last_line)      
    @batch.processing_time = (Time.now - start_time) * 1000
    @batch.line_count = line_count
  end
  
  
  def create_request_records
    requests = Hash.new
    Request.find_all_by_application_id(@app.id).each do |req|
      requests[req.action] ||= {}
      requests[req.action][req.time_source] = req
    end
    
    @request_total.stats.each do|action, stat|
      req_hash = requests[action] ||= {}
      
      {:total => @request_total,
        :db => @request_db,
        :render => @request_render,
        :action => @request_action}.each do |time_source, stats_hash|

        req_rec = req_hash[time_source.to_s] ||= Request.new(:action => action, :time_source => time_source.to_s, :application_id => @app.id)
        update_first_last_event_times(stats_hash, req_rec, action)
      
        event_log = stats_hash.stats[action].to_event_log
        event_log.log_source = req_rec
        
        @batch.event_logs << event_log
      end
      
      requests[action].each_value &:save
    end
  end
  
  def create_render_records
    templates = Hash.new
    Template.find_all_by_application_id(@app.id).each{|tmp| templates[tmp.path] = tmp}
    
    @render_stats.stats.each { |path, stat|
      tmp_rec = templates[path] ||= Template.new(:path => path, :application_id => @app.id)
      event_log = stat.to_event_log
      event_log.log_source = tmp_rec

      update_first_last_event_times(@render_stats, tmp_rec, path)
      tmp_rec.save!
      
      @batch.event_logs << event_log
    }
    
  end
  
  def update_first_last_event_times(stathash, rec, key)
      last_time = getTime(stathash.last_lines[key])
      rec.most_recent_event = last_time if rec.most_recent_event.nil? || rec.most_recent_event < last_time.to_time

      first_time = getTime(stathash.first_lines[key]) 
      rec.first_event = first_time if rec.first_event.nil? || rec.first_event > first_time.to_time
  end
  
end