require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'
require 'oauth'

require_relative './lib/outh_twitter'

enable :sessions

get '/' do
  if session[:access_token].nil? || session[:access_key].nil?
    redirect outh_twitter.get_authorize_url
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
  access_token = outh_twitter.get_access_token(pin)
  session[:access_token] = access_token.token
  session[:access_key] = access_token.secret
  erb :index
end

helpers do
  def outh_twitter
    @outh_twitter ||= OuthTwitter.new
  end
end

