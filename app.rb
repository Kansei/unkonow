require 'sinatra'
require 'sinatra/reloader'
require 'omniauth'
require 'omniauth-twitter'

require_relative './lib/auto_tweet'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :twitter, ENV.fetch('CONSUMER_KEY'), ENV.fetch('CONSUMER_SECRET_KEY')
end

get '/' do
  erb :index
end

post '/auth/open_id' do
  'Hello World'
end

post '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
end

get '/tweet' do
  # todo: 絵文字の追加, 非同期処理
  messages = %w(うんこなう うんぴょなう うんちっちなう うんちょなう うんぴょこなう うんぽこなう unko\ now I'm\ pooping\ now 大便大出來了 똥이\ 마렵따 )

  auto_tweet(messages.sample)
  redirect '/'
end
