module RabbitConsumer
  require 'logger'
  class CustomLogger < Logger
  
    def format_message(severity, timestamp, progname, msg)
      "#{timestamp} #{severity} #{msg}\n" 
      #.to_formatted_s(:db)
    end 

    def self.create(short_name)
      short_name ||= 'custom'
      dir = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'log'))
      logfile = File.open("#{dir}/#{short_name}.log", 'a')
      logfile.sync = true
      new(logfile)
    end
  end
end