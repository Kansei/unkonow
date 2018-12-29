require 'oauth'
require 'dotenv'

class OuthTwitter
  def initialize
    consumer_key = ENV.fetch('CONSUMER_KEY')
    consumer_secret = ENV.fetch('CONSUMER_SECRET_KEY')

    @consumer = OAuth::Consumer.new(
        consumer_key,
        consumer_secret,
        :site => 'https://api.twitter.com'
    )
  end

  def get_authorize_url
    request_token = @consumer.get_request_token(oauth_callback: 'https://unkonow.herokuapp.com/authorize')

    request_token.authorize_url
  end

  def get_access_token(oauth_verifier)
    @consumer.options.delete(:oauth_callback)
    request_token = @consumer.get_request_token
    access_token = request_token.get_access_token(
       oauth_token: request_token.token,
       oauth_verifier: oauth_verifier
    )
  end
end
