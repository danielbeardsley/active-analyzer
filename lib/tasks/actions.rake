namespace :process do
  task :log => :environment do
    app = Application.find_or_create_by_name(ENV['app'])
    p = Processor.new(app)
    file_path = ENV['log_file']
    
    input = if file_path.nil? then STDIN else File.new(file_path) end
    
    batch = p.consume_file(input)
  end
end