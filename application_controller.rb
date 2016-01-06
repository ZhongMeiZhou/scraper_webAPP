require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'json'
require 'chartkick'
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
    set :api_ver, 'api/v2'
  end

  configure :production, :development, :test do
    set :api_server, 'http://localhost:3000' # 'http://dynamozmz.herokuapp.com/'
  end

  configure :production, :development do
    enable :logging
  end

  # GUI route definitions
  get_root = lambda do
    @dashboard = 'active'
    @listings = 'none'
    slim :home
  end

  get_tour_search = lambda do
    @listings = 'active'
    @dashboard = 'none'
    slim :tours
  end

  post_tours = lambda do
    #logger.info(process_country_names(params[:tour_countries]))

    countries = process_country_names(params[:tour_countries])
    tours = post_api_tour(countries, params[:tour_categories], params[:inputPriceRange], settings)
    #logger.info(params[:tour_countries])

    if tours[:status] == true
      session[:results] = tours[:result]
      
      session[:action] = :create
      redirect "/tours/compare"
    else
      flash[:notice] = tours[:message]
      redirect "/tours"
    end
  end

  # here pass in results used to generate visualization
  get_tours_visualization = lambda do
    if session[:action] == :create
      @results = session[:results]
    else
      #get_api_tours(settings, params[:id])
      #if @results.code != 200
        flash[:notice] = "No results found"
        redirect "/tours"
      #end
    end
    logger.info(@results.series)
    logger.info(@results.drilldown)
    logger.info(@results.categories)
  
    @results
    slim :tours
  end

  # GUI Routes
  get '/', &get_root
  get "/tours", &get_tour_search
  post "/tours", &post_tours
  get '/tours/compare', &get_tours_visualization
end