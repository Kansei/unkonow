require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'

require_relative './lib/outh_twitter'

enable :sessions

get '/' do
  if session.nil?
    @twitter = OuthTwitter.new
    redirect @twitter.get_authorize_url
  end
  erb :index
end

get '/tweet' do
  erb :index
end

get '/authorize' do
  erb :authorize
end

post '/authorize' do
  pin = params[:pin]
  access_token = @twitter.get_access_token(pin)
  session[:access_token] = access_token.token
  session[:access_key] = access_token.secret
  erb :index
end



