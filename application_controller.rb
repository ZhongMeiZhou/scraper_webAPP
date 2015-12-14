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
    tours = post_api_tour(params[:tour_countries], params[:tour_categories], params[:inputPriceRange], settings)
    logger.info(params[:inputPriceRange])

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
      #@results = JSON.parse(session[:results])
    else
      #get_api_tours(settings, params[:id])
      #if @results.code != 200
        flash[:notice] = "No results found"
        redirect "/tours"
      #end
    end
    #@country = @results['country'].upcase
   # @tours = @results['tours']
    #logger.info(@results)

  @results = [
  {
    name: "Sales", 
    data: [
      ["2014", 1000], ["2015", 1170], ["2016", 660], ["2017", 1030]
    ]
  },
  {
    name: "Test", 
    data: [
      ["2014", 4000], ["2015", 1870], ["2016", 660], ["2017", 1030]
    ]
  }
]
    slim :tours
  end

  # GUI Routes
  get '/', &get_root
  get "/tours", &get_tour_search
  post "/tours", &post_tours
  get '/tours/compare', &get_tours_visualization
end