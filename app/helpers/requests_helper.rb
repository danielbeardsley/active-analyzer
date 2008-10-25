module RequestsHelper
  def total_time_column(record)
    tt = record.total_time.to_i
    tt.nil? ? nil : time_ago_in_words(Time.now - tt)
  end
end
