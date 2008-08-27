class TemplateController < BaseController
  def list
    @templates = Template.find(:all, :conditions => {:application_id => params[:application]})
  
    respond_to do |wants|
      wants.html { render :xml => @templates.to_xml }
      wants.xml { render :xml => @templates.to_xml }
    end
  end
  
  def summarize
    @templates = Template.find(:all, :conditions => {:application_id => params[:application]})
  end
end
