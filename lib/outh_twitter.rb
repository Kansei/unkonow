require 'oauth'
require 'json'
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

  def get_request_token
    @consumer.get_request_token(oauth_callback: 'https://unkonow.herokuapp.com/authorize')
  end

  def get_token_and_key_for_access(request_token, oauth_verifier)
    @consumer.options.delete(:oauth_callback)
    request_token.get_access_token(
       oauth_token: request_token.token,
       oauth_verifier: oauth_verifier
    )
  end

  def get_access_token(access_token, access_key)
    OAuth::AccessToken.new(@consumer, access_token, access_key)
  end

  def tweet(message, access_token)
    access_token.post('https://api.twitter.com/1.1/statuses/update.json', status: message)
  end
end
