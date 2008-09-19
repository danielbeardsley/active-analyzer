require(File.join(File.dirname(__FILE__), '../config', 'environment'))
require 'zlib'

OLD_LOGS = '/var/log/wikiwalki/old-logs/*.gz'

def process_zipped_log(filename)
    @processor.consume_file(Zlib::GzipReader.open(filename))
end

def setup
    @app = Application.find_or_create_by_name(ENV['app'])
    @processor = Processor.new(@app)
end

setup

Dir.glob(OLD_LOGS) do |file_name|
  process_zipped_log file_name
end
