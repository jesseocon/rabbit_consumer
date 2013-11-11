module RabbitConsumer
  class Mailer
    
    attr_accessor :to_email, :name, :html, :mandrill
    
    # @param
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
      @mandrill ||= Mandrill::API.new
    end
    
    def message 
      message = { 
        :subject    => "Thanks for joining FolioShine!",
        :from_name  => "Jesse Ocon",
        :text       => "Hi",
        :to => [{
          :email => self.to_email,
          :name   => self.name
        }],
        :html       => self.html,
        :from_email => 'jesseocon@gmail.com'
      }
    end
    
    def sendit
      repsonse = @mandrill.send(self.message)
    end
    
    def html
      "<html><h1>Hi <strong>#{self.name}</strong> thank you for joining Folioshine</h1></html>"
    end
    
  end
end

# m = Mandrill::API.new
# message = {  
#  :subject=> "Hello from the Mandrill API",  
#  :from_name=> "Jesse Ocon",  
#  :text=>"Hi Jesse, how are you?",  
#  :to=>[  
#    {  
#      :email=> "jesseocon@gmail.com",  
#      :name=> "Jesse Ocon"  
#    }  
#  ],  
#  :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",  
#  :from_email=>"jesseocon@gmail.com"  
# }  
# sending = m.messages.send message 