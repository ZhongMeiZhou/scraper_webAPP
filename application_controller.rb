require 'sinatra/base'

class ApplicationController < Sinatra::Base

	get '/' do
		'scraper_webapp is up and Running'
	end
end