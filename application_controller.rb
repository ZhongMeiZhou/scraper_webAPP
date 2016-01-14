require 'sinatra/base'
require 'sinatra/flash'
require 'slim'
require 'json'
require 'chartkick'
require_relative './helpers/web_helper.rb'

#Main app controller
class ApplicationController < Sinatra::Base
  include WebAppHelper

  use Rack::Session::Pool # seems to be fix to issue: Warning! Rack::Session::Cookie data size exceeds 4K. Content dropped.
  #enable :sessions # replace this optiona bcas causing size issues enable :sessions
  register Sinatra::Flash
  

  set :views, File.expand_path('../views', __FILE__)
  set :public_folder, File.expand_path('../public', __FILE__)

  configure do
    #enable :sessions
    set :session_secret, 'zmz!'
    set :api_ver, 'api/v2'
  end


  configure :production, :development, :test do
    set :api_server, 'http://dynamozmz.herokuapp.com/' #'http://localhost:3000' 
    #'http://localhost:3000' # 'http://dynamozmz.herokuapp.com/'
  end

  #configure :test do
   
    #use Rack::Session::Pool
   # set :domain, 'localhost'
   # set :api_server, 'http://dynamozmz.herokuapp.com/' 
  #end

 # configure :development, :test do
  #  set :api_server, 'http://dynamozmz.herokuapp.com'
    #set :api_server, 'http://localhost:3000' #'http://localhost:3000' # 'http://dynamozmz.herokuapp.com/'
  #end

  #configure :production, :development do
  #  set :api_server, 'http://dynamozmz.herokuapp.com'
  #  enable :logging
  #  set :domain, 'lptours.herokuapp.com'
    #use Rack::Session::Pool, :domain => 'lptours.herokuapp.com', :expire_after => 60 * 60 * 24 * 365
  #end

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
    puts '------Post request to get tours ------'
    puts "params : #{params}"
    session[:searchParams] = params
    #logger.info(params[:categories])
    categories = params[:tour_categories]

    if categories.nil?
     categories = ['Small Group Tours', 'Adventure', 'Sightseeing Tours', 'Health & Wellness', 'History & Culture']
    end
    params[:tour_countries].each do |t|
      t.gsub!('&', 'and')#.gsub(/\s+/, '-')
      t.gsub!(' ', '-')
    end
    puts params[:tour_countries].each{|t| t }
    tours = post_api_tour(params[:tour_countries], categories, params[:inputPriceRange], settings)


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

    logger = Logger.new(STDOUT)
    logger.info("CHECK SESSION ACTION:")
    logger.info(session[:action])

    if session[:action] == :create
      @results = session[:results]
      logger.info("CHECK RESULTS:")
      logger.info(@results)
    else
      #get_api_tours(settings, params[:id])
      #if @results.code != 200
        flash[:notice] = "No results found"
        redirect "/tours"
      #end
    end
    # [0][1..-1].gsub(/"|\[|\]|/, '').gsub(/\\u([a-f0-9]{4,5})/i){ [$1.hex].pack('U') }.split(',')
    # logger.info(@results.series)
    #logger.info(@results.drilldown)
    #logger.info(@results.categories)
    #logger.info(@results.tours)
    #logger.info(@results.categories[0][1..-1].gsub(/"|\[|\]|/, '').gsub(/\\u([a-f0-9]{4,5})/i){ [$1.hex].pack('U') }.split(',').map { |e| e })

    @results
    slim :tours
  end

  post_report = lambda do
    #puts params
    if session[:action] == :create
      report = post_api_report(params[:email], session[:results], settings)

      # Run worker
      if report[:status] == true
        return {message: "Processing your request. You can continue"}.to_json
      else
        return {message: "Error Processing your request. Please try again"}.to_json
      end
    else
      return {message: "Error Processing your request. Please try again"}.to_json
    end
    
  end

  # GUI Routes
  get '/', &get_root
  get "/tours", &get_tour_search
  post "/tours", &post_tours
  post "/report", &post_report
  get '/tours/compare', &get_tours_visualization
end
