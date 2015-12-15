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
    tours_result = TourCompareResults.new
    tours_result.code = result.code
    tours_result.results = result
    tours_result
  end
end
