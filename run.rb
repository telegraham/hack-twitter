require 'twitter'
require 'pry'
require 'httparty'
require 'dotenv'

Dotenv.load


def make_spotify_request(action = "resume")
  HTTParty.post("https://guc-spclient.spotify.com/connect-api/v2/from/13f5518e48d0ae9a338e2a787b9e00fdf1ae6290/device/71a88932a8c82058109c05c7bc9c4ea1df7adecc/#{action}",
    :headers => { 'authorization' => 'Bearer BQD47Yev5XGyhMQdEyavoYo8DoHN-6tWPxiVRE9e-5RIGRhsl-BnI-RpOHsCI8ErF-iSOkvvUdf87EzAhrKaAEIkpAXRF-48junYPpRX9WSwBrq13QUC--sgsa1gPDmsNgAdcKYz1idkbf5iBvazPg43_RPLOyVinsoBCSDA1ohLjTPNH19d3Zk13f5ZN_k1TcBPSBSe497YrFarg2nHJpSSjqWrUq3ud3M8FLfGVO7HURVRbfDtpME0qiq6YWzbDJOGnTet6PSf2rwTVrDYSSH9' } )
end

#set up the streaming client
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

#stream!
client.user do |object|
  case object
  when Twitter::Tweet
    puts object.user.screen_name
    puts object.text
    if object.text.include? "#flatironhouston"
      if object.text.include? "play"
        make_spotify_request("resume")
      elsif object.text.include? "pause"
        make_spotify_request("pause")
      end
    end
  when Twitter::DirectMessage
    puts "It's a direct message!"
  when Twitter::Streaming::StallWarning
    warn "Falling behind!"
  end
end



