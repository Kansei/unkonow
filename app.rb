require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry' if development?
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
  redirect '/not_support' if request.from_pc?

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

get '/not_support' do
  erb :not_support
end

get '/tweet' do
  access_token = twitter.get_access_token(session[:access_token], session[:access_key])

  message, lang = create_message

  response = twitter.tweet(message, access_token)

  if response.code == '200'
    flash[:notice] = "#{lang}でつぶやいたよ！\nTwitterで確認してみよう！"
  else
    flash[:notice] = "うんこしすぎじゃない？"
  end

  redirect '/'
end

helpers do
  def twitter
    @twitter ||= OuthTwitter.new
  end

  def create_message
    messages = ['うんこなう', 'I\'m pooping now', '我現在大便', '나는 지금 비틀 거리고있다', 'je suis caca maintenant', 'أنا أتعب الآن', 'estoy haciendo caca ahora', 'bây giờ tôi đang ị','ឥឡូវនេះខ្ញុំកំពុងធ្វើបាប', 'ನಾನು ಈಗ ಪೂಪಿಂಗ್ ಮಾಡುತ್ತಿದ್ದೇನೆ', 'sto facendo la cacca ora'].freeze

    langs = ['日本語', '英語', '中国語', '韓国語', 'フランス語', 'アラビア語', 'スペイン語', 'ベトナム語', 'クメール語', 'カンナダ語', 'イタリア語'].freeze

    random = Random.new(Time.now.sec)
    index = random.rand(messages.size)

    lang = langs[index]

    massage = attach_unko(messages[index], lang)

    [massage, lang]
  end

  def attach_unko(message, lang)
    random = Random.new(Time.now.sec)
    attach_way = random.rand(3)

    if attach_way == 0
      message_with_unko = "💩#{message}💩"
    elsif attach_way == 1
      message_with_unko = lang == 'アラビア語' ? "💩#{message}" : "#{message}💩"
    else
      message_with_unko = lang == 'アラビア語' ? "!#{message}" : "#{message}!"
    end
    message_with_unko
  end
end

