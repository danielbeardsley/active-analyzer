class Stat
  def initialize(key)
    @key=key
    @min = nil
    @max = nil
    @sum = 0
    @sum_squares = 0
    @count = 0
    @values = []
  end
  def add(value)
    value=1.0*value
    @count+=1
    @min = value unless @min
    @min = value if value<@min
    @max = value unless @max
    @max = value if value>@max
    @sum += value
    @sum_squares += value*value
    @values << value
  end
  
  attr_accessor :key, :count, :sum, :mean, :min, :max, :median
  
  def key
    @key
  end
  def count
    @count
  end
  def sum
    @sum
  end
  def min
    @min
  end
  def max
    @max
  end
  def average
    return 0 if(@count == 0)
    @sum/@count
  end
  def median
    return 0 unless @values
    l = @values.length
    return 0 unless l>0
    @values.sort!
    return (@values[l/2-1]+@values[l/2])/2 if l%2==0
    @values[(l+1)/2-1]
  end
  def standard_deviation
    return 0 if @count<=1
    avg_sqr_sum = (@sum_squares - (@sum*@sum / @count)) / @count
    return 0 if avg_sqr_sum < 0
    Math.sqrt(avg_sqr_sum)
  end
  def to_s
      sprintf("%-45s %6d %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f",key,count,sum,max,median,average,min,standard_deviation)
  end
  def to_event_log
    EventLog.new( :mean_time => average,
                  :min_time => @min,
                  :max_time => @max,
                  :median_time => median,
                  :std_dev => standard_deviation,
                  :event_count => @count,
                  :total_time => @sum)
  end
end
