require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'
require 'mechanize'

get '/' do
  erb :index
end

get '/tweet' do
  Dotenv.load
  agent = Mechanize.new
  agent.follow_meta_refresh = true
  agent.redirect_ok = true
  agent.user_agent_alias = 'Mac Safari'

  agent.get('https://twitter.com/login?lang=ja')

  puts agent.page.title

  agent.page.form_with(action: 'https://twitter.com/sessions') do |form|
    form.field_with(name: 'session[username_or_email]').value = ENV.fetch('EMAIL')
    form.field_with(name: 'authenticity_token').value = ENV.fetch('PASSWORD')
    form.click_button
  end

  puts agent.page.title
  redirect '/'
end
