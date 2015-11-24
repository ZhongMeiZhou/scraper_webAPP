ENV['RACK_ENV'] = 'test'

Dir.glob('./{helpers, forms}/*.rb').each { |file| require file }
require 'minitest/autorun'
require 'rack/test'
require 'watir-webdriver'
require 'headless'

include Rack::Test::Methods

def app
  ApplicationController
end