require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'
require 'rack/user_agent'
require 'rack/flash'

require_relative './lib/outh_twitter'

configure do
  use Rack::UserAgent
  use Rack::Flash
  enable :sessions
  set :request_token, ""
end

get '/' do
  # redirect '/not_support' if request.from_pc?
  #
  # if session[:access_token].nil?
  #   settings.request_token = twitter.get_request_token
  #   redirect settings.request_token.authorize_url
  # end
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

get '/not_support' do
  erb :not_support
end

get '/tweet' do
  access_token = twitter.get_access_token(session[:access_token], session[:access_key])

  messages = ['うんこなう', 'I\'m pooping now', '我現在大便', '나는 지금 비틀 거리고있다', 'je suis caca maintenant', 'أنا أتعب الآن', 'estoy haciendo caca ahora', 'bây giờ tôi đang ị', 'ឥឡូវនេះខ្ញុំកំពុងធ្វើបាប', 'ನಾನು ಈಗ ಪೂಪಿಂಗ್ ಮಾಡುತ್ತಿದ್ದೇನೆ', 'sto facendo la cacca ora
'].freeze

  langs = ['日本語', '英語', '中国語', '韓国語', 'フランス語', 'アラビア語', 'スペイン語', 'ベトナム語', 'クメール語', 'カンナダ語', 'イタリア語'].freeze

  index = rand(messages.size)

  lang = langs[index]
  message = messages[index]+'!'

  result = twitter.tweet(message, access_token)

  if result == 200
    flash[:notice] = "#{lang}で「うんこなう」とつぶやきました。\nTwitterで確認してみましょう！"
  else
    flash[:notice] = "Tweetに失敗しました。"
  end

  redirect '/'
end

helpers do
  def twitter
    @twitter ||= OuthTwitter.new
  end
end

