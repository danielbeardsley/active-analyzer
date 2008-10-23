class Batch < ActiveRecord::Base
  has_many :event_logs
  belongs_to :application
  
  def lines_per_second
    return 0 if self.line_count.nil? or self.processing_time.nil? or self.processing_time <= 0
    self.line_count / (self.processing_time / 1000)
  end
end
