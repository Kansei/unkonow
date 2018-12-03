require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'
require 'selenium-webdriver'

get '/' do
  erb :index
end

get '/tweet' do
  Dotenv.load

  driver = Selenium::WebDriver.for :firefox

  driver.navigate.to 'https://twitter.com/login?lang=ja'

  email = driver.find_element(:name, 'session[username_or_email]')
  email.send_keys ENV.fetch('EMAIL')

  email = driver.find_element(:name, 'session[password]')
  email.send_keys ENV.fetch('PASSWORD')

  button = driver.find_element(:css, '.submit')
  button.click

  redirect '/'
end
