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
    tours_result = TourCompareResults.new() #:categories => [result['data']['categories'].to_json]
    tours_result.code = result.code
    tours_result.series = result['data']['series']
    tours_result.drilldown = result['data']['drilldown']
    tours_result.categories = result['data']['categories']
    tours_result.countries = result['data']['countries']
    tours_result.tours = result['data']['tours']
    tours_result
  end
end
