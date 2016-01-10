require 'httparty'
require 'json'
require_relative '../forms/tour_form'
require_relative '../services/check_tour'
require_relative '../services/send_report'

# Tour search helper
module WebAppHelper
  def post_api_tour(country, category, price_range, settings)
    logger = Logger.new(STDOUT)
    submit = TourForm.new
    submit.tour_countries = country
    submit.tour_categories = category
    submit.inputPriceRange = price_range

    if submit.valid? == false
      { status: false, message: "Required: "+ submit.error_fields }
    else
      begin
        results = CheckToursFromAPI.new(settings, submit).call
        logger.info("IN POST API TOUR:")
        logger.info(results)
      rescue StandardError => e
        logger.info e.message
        halt 400, e.message
      end

      if (results.code != 200)
        { status: false, message: 'The Pony Express did not deliver the goods.' }
      else
        { status: true, result: results }
      end
    end
  end

  def post_api_report(email,result,settings)
    begin
        results = SendReport.new(settings, email,result).call
      rescue StandardError => e
        logger.info e.message
        halt 400, e.message
      end

      if (results.code != 200)
        { status: false, message: 'The Pony Express did not deliver the goods.' }
      else
        { status: true, result: results }
      end
  end

  def get_api_tours(settings, id)
    url = "#{settings.api_server}/#{settings.api_ver}/tours/#{id}"
    options = { headers: { 'Content-Type' => 'application/json' } }

    begin
      @results = HTTParty.get(url, options)
    rescue StandardError => e
      logger.info e.message
      halt 400, e.message
    end
  end

  #format names to match standard understood by lonelyplanet e.g. Trinidad & Tobago will not be understood, rather trinidad-and-tobago
  def process_country_names(country)
   # country.map do |c|
      country.gsub!('&', 'and')
      country.gsub /\s+/, '-'
   # end
  end
end