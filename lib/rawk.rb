=begin
module ActiveAnalyzer
  class Rawk
    VERSION = 1.2
    HEADER = "Request                                        Count     Sum     Max  Median     Avg     Min     Std"
    HELP = "\nRAWK - Rail's Analyzer With Klass v#{VERSION}\n"+
    "Created by Chris Hobbs of Spongecell, LLC\n"+
    "This tool gives statistics for Ruby on Rails log files. The times for each request are grouped and totals are displayed. "+
    "If process ids are present in the log files then requests are sorted by ActionController actions otherwise requests are grouped by url. "+
    "By default total request times are used for comparison but database time or render time can be used by specifying the correct flag. "+
    "The log file is read from standard input unless the -f flag is specified.\n\n"+
    "The options are as follows:\n\n"+
    "  -?  Display this help.\n\n"+
    "  -d  Use DB times as data points. These times are found after 'DB:' in the log file. This overrides the default behavior of using the total request time.\n\n"+
    "  -f <filename> Use the specified file instead of standard input.\n\n"+
    "  -h  Display this help.\n\n"+
    "  -r  Use Render times as data points. These times are found after 'Rendering:' in the log file. This overrides the default behavior of using the total request time.\n\n"+
    "  -s <count> Display <count> results in each group of data.\n\n"+
    "  -t  Test\n\n"+
    "  -u  Group requests by url instead of the controller and action used. This is the default behavior if there is are no process ids in the log file.\n\n"+
    "  -w <count> Display the top <count> worst requests.\n\n"+
    "To include process ids in your log file, add this to environment.rb:\n\n"+
    "  class Logger\n"+
    "    def format_message(severity, timestamp, progname, msg)\n"+
    "      \"\#{msg} (pid:\#{$$})\\n\"\n"+
    "    end\n"+
    "  end\n"+
    "\n"+
    "This software is Beerware, if you like it, buy yourself a beer.\n"
  
    def initialize
      @start_time = Time.now
      build_arg_hash
      if @arg_hash.keys.include?("?") || @arg_hash.keys.include?("h")
        puts HELP
      elsif @arg_hash.keys.include?("t")
        Stat.test
      else
        init_args
        build_stats
        print_stats
      end
    end
    def build_arg_hash
      @arg_hash = Hash.new
      last_key=nil
      for a in $*
        if a.index("-")==0 && a.length>1
          a[1,1000].scan(/[a-z]|\?/).each {|c| @arg_hash[last_key=c]=nil}
          @arg_hash[last_key] = a[/\d+/] if last_key
        elsif a.index("-")!=0 && last_key
          @arg_hash[last_key] = a
        end
      end
      #$* = [$*[0]]
    end
    def init_args
      @sorted_limit=20
      @worst_request_length=20
      @force_url_use = false
      @db_time = false
      @render_time = false
      @input = $stdin
      keys = @arg_hash.keys
      @force_url_use = keys.include?("u")
      @db_time = keys.include?("d")
      @render_time = keys.include?("r")
      @worst_request_length=(@arg_hash["w"].to_i) if @arg_hash["w"]
      @sorted_limit = @arg_hash["s"].to_i if @arg_hash["s"]
      @input = File.new(@arg_hash["f"]) if @arg_hash["f"]
    end
    def build_stats
      @stat_hash = StatHash.new
      @total_stat = Stat.new("All Requests")
      @worst_requests = []
      last_actions = Hash.new
      while @input.gets
        if $_.index("Processing ")!=nil
          action = $_.split[6]
          pid = $_[/rails\[\d+\]/]
          #pid = $_[/\(pid\:\d+\)/]
          last_actions[pid]=action if pid
          next
        end
        next unless $_.index("Completed in")!=nil
        pid = key = nil
        #get the pid unless we are forcing url tracking
        #pid = $_[/\(pid\:\d+\)/] if !@force_url_use
         pid = $_[/rails\[\d+\]/] if !@force_url_use
        next unless pid
        key = last_actions[pid] if pid
        time = 0.0
        if @db_time
          time_string = $_[/DB: \d+\.\d+/]
        elsif @render_time
          time_string = $_[/Rendering: \d+\.\d+/]
        else
          time_string = $_[/Completed in \d+\.\d+/]
        end
        time_string = time_string[/\d+\.\d+/] if time_string
        time = time_string.to_f if time_string
        #if pids are not specified then we use the url for hashing
        #the below regexp turns "[http://spongecell.com/calendar/view/bob]" to "/calendar/view"
        key = ($_[/\[\S+\]/].gsub(/\S+\/\/(\w|\.)*/,''))[/\/\w*\/?\w*/] unless key
        @stat_hash.add(key,time)
        @total_stat.add(time)
        if @worst_requests.length<@worst_request_length || @worst_requests[@worst_request_length-1][0]<time
          @worst_requests << [time,$_]
          @worst_requests.sort! {|a,b| (b[0] && a[0]) ? b[0]<=>a[0] : 0}
          @worst_requests=@worst_requests[0,@worst_request_length]
        end
      end
    end
    def print_stats
      puts "Printing report for #{@db_time ? 'DB' : @render_time ? 'render' : 'total'} request times"
      puts "--------"
      puts HEADER
      puts @total_stat.to_s
      puts "--------"
      @stat_hash.print()
      puts "\nTop #{@sorted_limit} by Count"
      puts HEADER
      @stat_hash.print(:sort_by=>"count",:limit=>@sorted_limit,:ascending=>false)
      puts "\nTop #{@sorted_limit} by Sum of Time"
      puts HEADER
      @stat_hash.print(:sort_by=>"sum",:limit=>@sorted_limit,:ascending=>false)
      puts "\nTop #{@sorted_limit} Greatest Max"
      puts HEADER
      @stat_hash.print(:sort_by=>"max",:limit=>@sorted_limit,:ascending=>false)
      puts "\nTop #{@sorted_limit} Least Min"
      puts HEADER
      @stat_hash.print(:sort_by=>"min",:limit=>@sorted_limit)
      puts "\nTop #{@sorted_limit} Greatest Median"
      puts HEADER
      @stat_hash.print(:sort_by=>"median",:limit=>@sorted_limit,:ascending=>false)
      puts "\nTop #{@sorted_limit} Greatest Standard Deviation"
      puts HEADER
      @stat_hash.print(:sort_by=>"standard_deviation",:limit=>@sorted_limit,:ascending=>false)
      puts "\nWorst Requests"
      @worst_requests.each {|w| puts w[1].to_s}
      puts "\nCompleted report in #{(Time.now.to_i-@start_time.to_i)/60.0} minutes -- spongecell"
    end
  end
end

Rawk.new
=end
