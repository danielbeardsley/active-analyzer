module ApplicationsHelper
#  def name_column(app)
#    link_to app.name, :controller => 'applications', :action => 'view', :id => app.id
#  end
  
  def batches_count_column(app)
    app.batches.count
  end
  
  def most_recent_batch_column(app)
    app.batches.maximum :last_event
  end
  
  def batches_column(app)
    app.batches.count
  end
end
