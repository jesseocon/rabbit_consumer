require "rubygems"
require "openssl"
require 'amqp'
require 'json'
require 'httparty'
require 'mandrill'
$:.unshift File.dirname(__FILE__)

require './lib/consumer/mailer.rb'

module RabbitConsumer

  # run loop customize to process stuff
  EventMachine.run do
    AMQP.connect(ENV['RABBITMQ_BIGWIG_RX_URL']) do |connection|
      
      channel = AMQP::Channel.new(connection)
      
      exchange = channel.topic('folioemail', auto_delete: true)
      
      queue = channel.queue("email.welcome").bind(exchange, routing_key: 'email.welcome')
      
      queue.subscribe do |payload|
        custom_logger.info(payload)
        
        # json should be {"to_email":"jesseocon@gmail.com", "name":"Jesse Ocon"}
        mailer = RabbitConsumer::Mailer.new(params)
        mailer.sendit
      end

      show_stopper = Proc.new { connection.close { EventMachine.stop } }
      Signal.trap "TERM", show_stopper
      Signal.trap "INT", show_stopper
    end
  end

end


