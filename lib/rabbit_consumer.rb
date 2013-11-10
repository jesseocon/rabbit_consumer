require "rubygems"
require "openssl"
require 'amqp'
require 'json'
require 'httparty'
$:.unshift File.dirname(__FILE__)

require 'consumer/custom_logger.rb'

module RabbitConsumer
  
  RABBIT_MQ_CREDS = {
    :host      => "127.0.0.1",
    :port      => 5672,
    :user      => "guest",
    :pass      => "guest",
    :vhost     => "/",
    :ssl       => false,
    :heartbeat => 0,
    :frame_max => 131072
  }
  
  # run loop customize to process stuff
  EventMachine.run do
    AMQP.connect(RABBIT_MQ_CREDS) do |connection|
      
      channel = AMQP::Channel.new(connection)
      custom_logger = RabbitConsumer::CustomLogger.new('email')
      custom_logger.info("starting Rabbit MQ Consumer") 
      
      
      exchange = channel.topic('folioemail', auto_delete: true)
      queue = channel.queue("email.welcome").bind(exchange, routing_key: 'email.welcome')
      queue.subscribe do |payload|
        custom_logger.info(payload)
      end

      show_stopper = Proc.new { connection.close { EventMachine.stop } }
      Signal.trap "TERM", show_stopper
      Signal.trap "INT", show_stopper
    end
  end

end

