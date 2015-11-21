require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'json'
require_relative './helpers/web_helper.rb'

class ApplicationController < Sinatra::Base
	include WebAppHelper

	enable :sessions
	register Sinatra::Flash

	set :views, File.expand_path('../../views', __FILE__)
	set :public_folder, File.expand_path('../../public', __FILE__)

	configure do
		set :session_secret, 'zmz!'
    		set :api_ver, 'api/v1'
	end
	
	configure :production do
    		set :api_server, 'http://zmztours.herokuapp.com'
  	end

	configure :production, :development do
    		enable :logging
  	end

	# GUI Lambdas
 	get_root = lambda do
    		slim :home
  	end

	get_tour_search = lambda do
    		slim :tours
  	end
	
	post_tours = lambda do
    		request_url = "#{settings.api_server}/#{settings.api_ver}/tours"
    		country_tour = post_api_tour(params[:tour], request_url)		
    		if country_tour['status'] == true
			session[:results] = country_tour['result']
    			session[:action] = :create
			redirect "/tours/#{country_tour['id']}"
		else			
      			flash[:notice] = country_tour['message']
      			redirect "/tours"
    		end
  	end

	get_tours = lambda do
    		if session[:action] == :create
      			@results = JSON.parse(session[:results])
    		else
      			request_url = "#{settings.api_server}/#{settings.api_ver}/tours/#{params[:id]}"
      			get_api_tours (request_url)
      			if @results.code != 200
        			flash[:notice] = "Cannot find any tours for #{params[:country]}"
        			redirect "/#{settings.api_ver}/tours"
      			end
    		end
    		@country = @results['country'].upcase
    		@tours = JSON.parse(@results['tours'])
    		slim :tours
  	end


  	# GUI Routes
  	get '/', &get_root
  	get "/tours", &get_tour_search
  	post "/tours", &post_tours
  	get '/tours/:id', &get_tours
end
