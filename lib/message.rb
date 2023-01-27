require "dotenv/load"
require "twilio-ruby"

class Message
  def initialize
    account_sid = ENV["TWILIO_ACCOUNT_SID"]
    auth_token = ENV["TWILIO_AUTH_TOKEN"]
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    @recipient = ENV["RECIPIENT_NUMBER"]
    @sender = ENV["TWILIO_NUMBER"]
  end

  def dispatch(message)
    @client.messages.create(to: @recipient, from: @sender, body: message)
  end
end
