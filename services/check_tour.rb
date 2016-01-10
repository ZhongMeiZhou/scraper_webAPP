require 'virtus'
require 'active_model'
require_relative '../models/tour_compare_results'

class CheckToursFromAPI
  def initialize(api, params_h)
    @request_url = "#{api.api_server}/#{api.api_ver}/tour_compare"
    @options =  { body: params_h.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    result = HTTParty.post(@request_url, @options)
    tours_result = TourCompareResults.new()
    tours_result.code = result.code
    tours_result.series = result['data']['series']
    tours_result.drilldown = result['data']['drilldown']
    tours_result.filtered_categories = result['data']['filtered_categories']
    tours_result.all_categories = result['data']['all_categories']
    tours_result.tours = result['data']['tours']

    logger.info("CHECK RETURNED RESULTS FROM API:")
    logger.info(tours_result)
    tours_result
  end
end
