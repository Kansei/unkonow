require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/auto_tweet'

get '/' do
  erb :index
end

get '/tweet' do
  messages = %w(うんこなう うんぴょなう うんちっちなう うんちょなう うんぴょこなう うんぽこなう unko\ now I'm\ pooping\ now 大便大出來了 똥이\ 마렵따 )

  auto_tweet(messages.sample)
  redirect '/'
end
