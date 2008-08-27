module Mixins
  module DefaultLogFormat
    SKIP = 16#characters
    
=begin
01234567890123456
Jul  1 06:28:47 rails ww_log[28524]: Processing MytrailsController#index (for 65.55.209.227 at 2008-07-01 06:28:46) [GET]
Jul  1 06:28:47 rails ww_log[28524]: Session ID: ab49e23f31bdfb896b64982a00fbdf81
Jul  1 06:28:47 rails ww_log[28524]: Parameters: {"action"=>"index", "controller"=>"mytrails", "sort_direction"=>"ASC", "sort"=>"title", "page"=>"1"}
Jul  1 06:28:47 rails ww_log[28524]: Cookie set: anon_user=EquRgwbTcKUX7WId; path=/; expires=Thu, 01 Jan 2009 11:28:46 GMT
Jul  1 06:28:47 rails ww_log[28524]: SQL (0.072714)   SELECT count(*) AS count_all FROM `trails` WHERE (id IN (SELECT trail_id from my_trails WHERE user_id = 'EquRgwbTcKUX7WId') OR created_by_user_id = 'EquRgwbTcKUX7WId') 
Jul  1 06:28:47 rails ww_log[28524]: Trail Load (0.083227)   SELECT * FROM `trails` WHERE (id IN (SELECT trail_id from my_trails WHERE user_id = 'EquRgwbTcKUX7WId') OR created_by_user_id = 'EquRgwbTcKUX7WId') ORDER BY trails.`title` ASC LIMIT 0, 15
Jul  1 06:28:47 rails ww_log[28524]: CACHE (0.000000)   SELECT * FROM `trails` WHERE (id IN (SELECT trail_id from my_trails WHERE user_id = 'EquRgwbTcKUX7WId') OR created_by_user_id = 'EquRgwbTcKUX7WId') ORDER BY trails.`title` ASC LIMIT 0, 15
Jul  1 06:28:47 rails ww_log[28524]: Rendering template within layouts/main
Jul  1 06:28:47 rails ww_log[28524]: Rendering mytrails/list
Jul  1 06:28:47 rails ww_log[28524]: Rendered mytrails/_list_header (0.00226)
Jul  1 06:28:47 rails ww_log[28524]: Tag Load (0.005425)   SELECT * FROM `tags` 
Jul  1 06:28:47 rails ww_log[28524]: Rendered /shared/_tags_js.html.erb (0.01165)
Jul  1 06:28:47 rails ww_log[28524]: Rendered mytrails/_list (0.04721)
Jul  1 06:28:47 rails ww_log[28524]: AppInfo Load (0.003645)   SELECT * FROM `app_info` WHERE (`app_info`.`id` = 'elevation_service') LIMIT 1
Jul  1 06:28:47 rails ww_log[28524]: Rendered shared/_account_links (0.00470)
Jul  1 06:28:47 rails ww_log[28524]: Rendered shared/_left_nav_bar (0.00664)
Jul  1 06:28:47 rails ww_log[28524]: Completed in 0.27872 (3 reqs/sec) | Rendering: 0.08294 (29%) | DB: 0.16501 (59%) | 200 OK [http://wikiwalki.com/mytrails?page=1&sort=title&sort_direction=ASC]
Jul  1 06:28:47 rails ww_log[28524]: Rendered shared/_account_links (0.00470)

getEventInfo returns one of:
  {:type => :completed, total: seconds, db: seconds, render: seconds},
  {:type => :processing, :action => "action_being_processed"},
  {:type => :rendered, :template => "templated_rendered", :time => seconds},
  {:type => :db_load, :table => "TableName", :time => seconds},
  {:type => :sql, :time => seconds}  

Any other :type values are ignored by ActiveAnalyzer::Processor
=end
    def getTime(line)
      line.nil? ? nil : begin DateTime.parse(line[0..SKIP-1]) rescue nil end
    end

    def getProcessId(line)
      return nil if line.nil?
      
      pos = line.index('[', SKIP)
      return nil if pos.nil?
      
      text = line[pos + 1, 10]
      return text.to_i if not text.blank?
    end
    
    #if this line is a "last message repeated X times" line, return X
    def getRepeatedCount(line)
      return nil if line.nil?
      after_app = line.index(' ', SKIP)
      if (not after_app.nil?) and line[after_app + 1, 9] == 'last mess'
        line[after_app + 23, 5].to_i
      else
        0
      end
    end
    
    def getEventInfo(line)
      return nil if line.nil?
      
      info = {}
      pos = line.index(']:', SKIP)
      return nil if pos.nil?
      
      type_start = pos + 3
      pos = line.index(' ', type_start)
      return nil if pos.nil?
      type_end = pos - 1
      
      type = line[type_start..type_end]
      info[:type] = type.downcase.to_sym
      
      #move the position to the beginning of whatever is after the event type
      type_end += 2

      case info[:type]
        when :processing
          action_end = line.index(' ', type_end)-1
          info[:action] = line[type_end..action_end]
          
        when :completed
          pos = line.index('in ', type_end);
          return nil if pos.nil?
          start = pos + 3
          info[:total] = line[start, 10].to_f

          start = line.index('DB: ', type_end)
          info[:db] = start.nil? ? 0 : line[start + 4, 9].to_f
          
          start = line.index('Rendering: ', type_end)
          info[:render] = case start
                            when nil then info[:total] - info[:db]
                            else line[start + 11, 9].to_f
                          end

        when :rendered
          template_end = line.index(' ', type_end) - 1
          info[:template] = line[type_end..template_end]
          info[:time] = line[template_end+3..-1].to_f
        
        when :rendering
          #do nothing
        
        else
          if line[type_end, 4] == "Load"
            info[:table] = type
            info[:type] = :db_load
            info[:time] = line[type_end+6, 10].to_f
          end

      end
      
      return info
    end      
  end
end