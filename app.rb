require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/tweet' do
  redirect '/'
end
