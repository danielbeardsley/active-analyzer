class ApplicationsController < BaseController
  active_scaffold :applications do |config|
    config.columns = [:name, :batches, :most_recent_batch]
    config.create.columns = [:name]
    
    config.list.sorting = {:name => :asc}

    config.columns[:batches].label = "Total Batches Processed"

    config.actions = [:list, :create]
    config.columns[:name].set_link('view', :page => true)
  end
  
  def destroy
  end

  def view
    @app = Application.find(params[:id])
  end
end
