require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'json'
require_relative './helpers/web_helper.rb'

#Main app controller
class ApplicationController < Sinatra::Base
	include WebAppHelper

	enable :sessions
	register Sinatra::Flash

	set :views, File.expand_path('../views', __FILE__)
	set :public_folder, File.expand_path('../public', __FILE__)

	configure do
		set :session_secret, 'zmz!'
    set :api_ver, 'api/v1'
	end

	configure :production, :development, :test do
    set :api_server, 'http://zmztours.herokuapp.com'
  end

	configure :production, :development do
    enable :logging
  end

	# GUI route definitions
 	get_root = lambda do
    @dashboard = 'active'
    @listings = 'none'
    slim :tours
  end

	get_tour_search = lambda do
    @listings = 'active'
    @dashboard = 'none'
    slim :tours
  end

	post_tours = lambda do
    country_tour = post_api_tour(params[:tour], settings)

    if country_tour[:status] == true
      session[:results] = country_tour[:result]
      session[:action] = :create
			redirect "/tours/#{country_tour[:result]['id']}"
    else
      flash[:notice] = country_tour[:message]
      redirect "/tours"
    end
  end

	get_tours = lambda do
    if session[:action] == :create
      @results = JSON.parse(session[:results])
    else
      get_api_tours(settings, params[:id])
      if @results.code != 200
        flash[:notice] = "Cannot find any tours for #{params[:country]}"
        redirect "/tours"
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
