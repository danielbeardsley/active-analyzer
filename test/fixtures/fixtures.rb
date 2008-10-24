class CustomFixtures
  def initialize
    create_all_records
  end
  
  def create_all_records
    if db_empty?
      delete_all_records
      create_applications
      create_batches
      create_requests
      create_templates
      create_event_logs
    end
  end

  def db_empty?
    Application.count <= 0
  end
  
  def delete_all_records
    [Application, Batch, Request, Template, EventLog].each do |klass|
      klass.delete_all
    end
  end
  
  def all_batches
    @all_batches ||= Batch.all
  end

  def all_applications
    @all_applications ||= Application.all
  end
  
  def create_applications
    2.times do |app_index|
      puts "Creating Application ... "
      Application.create(:name => "Application #{app_index}")
    end
  end

  def create_batches
    all_applications.each do |app|
      3.times do |i|
        date = i.days.ago.beginning_of_day
        puts "Creating Batch ... "
        app.batches.create(:first_event => date, :last_event => date.end_of_day,
            :line_count => (i+1) * 1000, :processing_time => (i+1) * 1000)
      end
    end
  end

  def create_requests
    all_applications.each do |app|
      2.times do |controller|
        controller_name = "Controller\#action#{controller}"
        %w(total db render acion).each do |time_source|
          puts "Creating Request ... "
          app.requests.create(:action => controller_name, :first_event => 4.days.ago.beginning_of_day,
              :most_recent_event => Time.now.end_of_day,
              :time_source => time_source)
        end
      end
    end
  end

  def create_templates
    all_applications.each do |app|
      2.times do |template|
        template_path = "template#{template}"
        puts "Creating Template ... "
        app.templates.create(:path => template_path, :first_event => 4.days.ago.beginning_of_day,
            :most_recent_event => Time.now.end_of_day)
      end
    end
  end
  
  def create_event_logs
    (Request.all + Template.all).each do |log_source|
      create_event_logs_for_log_source(log_source)
    end
  end
  
  def create_event_logs_for_log_source(source)
    count = 0
    all_batches.each do |batch|
      count += 1
      source.event_logs.create(:batch_id => batch.id,
        :log_source_type => source.class.name,
        :log_source_id => source.id,
        :event_count => batch.line_count / 10,
        :mean_time => count,
        :max_time => count * 2,
        :min_time => count / 2,
        :median_time => count,
        :std_dev => count / 2,
        :total_time => count * batch.line_count / 10)
    end
  end
end

CustomFixtures.new