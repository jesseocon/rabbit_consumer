require "spec_helper"

describe RabbitConsumer::Mailer do
  
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
  
  MAN_MESSAGE = {
    :subject => "Thanks for joining FolioShine!",
    :from_name => "Jesse Ocon",
    :text => "Hi",
    :to => [
      {
        :email => 'jesseocon@gmail.com',
        :name   => "Jesse Ocon"
      }
    ],
    :html       => "<html><h1>Hi <strong>Jesse Ocon</strong> thank you for joining Folioshine</h1></html>",
    :from_email => "jesseocon@gmail.com"
  } 
  
  let(:mailer) { FactoryGirl.build(:mailer) }
  subject { mailer }
  
  it { should respond_to(:to_email) }
  it { should respond_to(:name) }
  it { should respond_to(:html) }
  it { should respond_to(:mandrill) }
  it { should respond_to(:message) }
  
  describe 'Mailer#message' do
    it 'should return the correct format for the mandrill api' do
      mailer.message.should == MAN_MESSAGE
    end
  end
  
  describe 'the response from Mailer#sendit' do
    it "should return the correct response" do
      response = mailer.sendit
      response.first["email"].should == mailer.to_email
      response.first["status"].should == 'sent'
    end
  end
  
  describe 'the response when the email address is invalid' do
    it 'should return an error response' do
      mailer.to_email = 'wrongaddress@jesse,com'
      response = mailer.sendit
      response.first["status"].should == 'invalid'
    end
  end
  
  
end