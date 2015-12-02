require 'httparty'
require 'json'
require_relative '../forms/tour_form'
require_relative '../services/check_tour'

# Tour search helper
module WebAppHelper
  def post_api_tour(country, settings)
    submit = TourForm.new
    submit.country = country

    if submit.valid? == false
      { status: false, message: 'You broke it!' }
    else
      begin
        results = CheckToursFromAPI.new(settings, submit).call
      rescue StandardError => e
        logger.info e.message
        halt 400, e.message
      end

      if (results.code != 200)
        { status: false, message: 'The Pony Express did not deliver the goods.' }
      else
        { status: true, result: results.to_json }
      end
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
end
