require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'

require_relative './lib/outh_twitter'

enable :sessions
set :request_token, ""

get '/' do
  if session[:access_token].nil?
    settings.request_token = twitter.get_request_token
    redirect settings.request_token.authorize_url
  end
  erb :index
end

get '/authorize' do
  oauth_verifier = params[:oauth_verifier]
  request_token = settings.request_token
  access_token = twitter.get_token_and_key_for_access(request_token, oauth_verifier)

  session[:access_token] = access_token.token
  session[:access_key] = access_token.secret
  redirect '/'
end

get '/tweet' do
  access_token = twitter.get_access_token(session[:access_token], session[:access_key])

  messages = ["こんにちは", "おはよう", "こんばんわ"]
  result = twitter.tweet(messages.sample, access_token)

  puts result

  redirect '/'
end

helpers do
  def twitter
    @twitter ||= OuthTwitter.new
  end
end

