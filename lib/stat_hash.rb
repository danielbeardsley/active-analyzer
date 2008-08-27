class StatHash
  attr_reader :stats, :first_lines, :last_lines
  
  def initialize
    @stats = Hash.new
    @first_lines = Hash.new
    @last_lines = Hash.new    
  end
  
  def add(key, time, line)
    stat = @stats[key] || (@stats[key] = Stat.new(key))
    @last_lines[key] = line
    @first_lines[key] = line if not @first_lines.has_key?(key)
    stat.add(time)
  end
end