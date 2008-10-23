class Batch < ActiveRecord::Base
  has_many :event_logs
  belongs_to :application
  
  def lines_per_second
    self.line_count / self.processing_time if self.processing_time? and self.processing_time > 0
    0
  end
end
