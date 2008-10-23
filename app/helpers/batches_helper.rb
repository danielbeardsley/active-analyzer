module BatchesHelper
  def lines_per_second_column(batch)
    batch.line_count / batch.processing_time if batch.processing_time
  end
end
