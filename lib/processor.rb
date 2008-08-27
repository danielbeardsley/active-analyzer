class Processor
  include Mixins::DefaultLogFormat
  
  def initialize(application)
    @app = application
  end
  
  def consume_file(input_stream)
    @input = input_stream
    
    create_batch_record
    
    build_stats
   
    create_template_records
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
    @request_stats = StatHash.new
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
            @request_stats.add(action, info[:total], line) if not action.nil?
          
          when :rendered
            @render_stats.add(info[:template], info[:time], line)
          
          else
        end

        line_count += 1
      end
      
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
  
  
  def create_template_records
    requests = Hash.new
    Request.find(:all).each{|req| requests[req.action] = req}
    
    @request_stats.stats.map { |action, stat|
      req_rec = requests[action] || (requests[action] = Request.new(:action => action))
      event_log = stat.to_event_log
      event_log.log_source = req_rec
      
      update_first_last_event_times(@request_stats, req_rec, action)      
      req_rec.save
      
      @batch.event_logs << event_log
      event_log
    }
  end
  
  def create_render_records
    templates = Hash.new
    Template.find(:all).each{|tmp| templates[tmp.path] = tmp}
    
    @render_stats.stats.map { |path, stat|
      tmp_rec = templates[path] || (templates[path] = Template.new(:path => path))
      event_log = stat.to_event_log
      event_log.log_source = tmp_rec

      update_first_last_event_times(@render_stats, tmp_rec, path)
      tmp_rec.save
      
      @batch.event_logs << event_log
      event_log
    }
  end
  
  def update_first_last_event_times(stathash, rec, key)
      last_time = getTime(stathash.last_lines[key])
      rec.most_recent_event = last_time if rec.most_recent_event.nil? || rec.most_recent_event < last_time.to_time

      first_time = getTime(stathash.first_lines[key]) 
      rec.first_event = first_time if rec.first_event.nil? || rec.first_event > first_time.to_time
  end
  
end