ENV['RACK_ENV'] = 'test'

Dir.glob('./{helpers, forms, models, specs}/*.rb').each { |file| require file }
require 'minitest/autorun'
require 'rack/test'
require 'watir-webdriver'
require 'headless'
require 'page-object'

include Rack::Test::Methods

def app
  ApplicationController
end
