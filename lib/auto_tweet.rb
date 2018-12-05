require 'selenium-webdriver'
require 'dotenv'


def auto_tweet(message)
  Dotenv.load

  # options = Selenium::WebDriver::Chrome::Options.new
  # options.add_argument('--headless')
  # driver = Selenium::WebDriver.for :chrome, options: options

  driver = Selenium::WebDriver.for :chrome

  url = 'https://twitter.com/login?lang=ja'
  driver.get url

  driver.find_element(:name, 'session[username_or_email]').send_keys ENV.fetch('EMAIL')
  driver.find_element(:xpath, '//*[@id="page-container"]/div/div[1]/form/fieldset/div[2]/input').send_keys ENV.fetch('PASSWORD')
  driver.find_element(:xpath, '//*[@id="page-container"]/div/div[1]/form/div[2]/button').click

  sleep 1

  driver.find_element(:xpath, '//*[@id="tweet-box-home-timeline"]').send_keys message
  driver.find_element(:xpath, '//*[@id="timeline"]/div[2]/div/form/div[3]/div[2]/button').click

  sleep 1

  driver.quit
end

auto_tweet("hahahha")
