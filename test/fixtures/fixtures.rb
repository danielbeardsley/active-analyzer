class CustomFixtures
  def initialize
    create_all_records
  end
  
  def create_all_records
    if test_mode? && (db_empty? || test_data_expired?)
      delete_all_records
      create_applications
      create_batches
      create_requests
      create_templates
      create_event_logs
      puts 'Done Loading Fixtures'
    end
  end

  def test_mode?
    RAILS_ENV == 'test'
  end

  def db_empty?
    Application.count <= 0
  end
  
  def test_data_expired?
     Time.now > Batch.maximum(:last_event)
  end
  
  def delete_all_records
    puts 'Deleting all records in test database'
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
      Application.create(:name => "Application #{app_index}", :id => app_index)
    end
  end

  def create_batches
    print "\nCreating Batches"
    all_applications.each do |app|
      3.times do |i|
        date = i.days.ago.beginning_of_day
        print '.'
        app.batches.build(:first_event => date, :last_event => date.end_of_day,
            :line_count => (i+1) * 1000, :processing_time => (i+1) * 1000)
      end
      app.save
    end
  end

  def create_requests
    print "\nCreating Requests"
    all_applications.each do |app|
      2.times do |controller|
        controller_name = "Controller\#action#{controller}"
        %w(total db render action).each do |time_source|
          print '.'          
          app.requests.build(:action => controller_name, :first_event => 4.days.ago.beginning_of_day,
              :most_recent_event => Time.now.end_of_day,
              :time_source => time_source)
        end
      end
      app.save
    end
  end

  def create_templates
    print "\nCreating Templates"    
    all_applications.each do |app|
      2.times do |template|
        template_path = "template#{template}"
        print '.'
        app.templates.build(:path => template_path, :first_event => 4.days.ago.beginning_of_day,
            :most_recent_event => Time.now.end_of_day)
      end
      app.save
    end
  end
  
  def create_event_logs
    print "\nCreating Event Logs"    
    all_applications.each_with_index do |app, app_index|
      app.batches.each_with_index do |batch, count|
        create_event_logs_for_batch(batch, (app_index * 3) + (count + 1))
      end
    end
  end
  
  def create_event_logs_for_batch(batch, index)
    app = all_applications.find {|app| app.id == batch.application_id }
    (app.requests + app.templates).each do |source|
      print '.'
      batch_index = source.is_a?(Request) && source.time_source != 'total' ? index.to_f / 2 : index.to_f
      batch.event_logs.build(
        :log_source_type => source.class.name,
        :log_source_id => source.id,
        :event_count => batch.line_count / 10,
        :mean_time => batch_index,
        :max_time => batch_index * 2,
        :min_time => batch_index / 2,
        :median_time => batch_index,
        :std_dev => batch_index / 2,
        :total_time => batch_index * batch.line_count / 10)
    end
    batch.save
  end
end

CustomFixtures.new