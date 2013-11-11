FactoryGirl.define do
  factory(:mailer, class: RabbitConsumer::Mailer) do
    to_email 'jesseocon@gmail.com'
    name 'Jesse Ocon'
  end
end