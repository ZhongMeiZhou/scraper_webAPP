require 'virtus'
require 'active_model'
<<<<<<< HEAD
require_relative '../models/tour_compare_results'

class CheckToursFromAPI
  def initialize(api, params_h)
    @request_url = "#{api.api_server}/#{api.api_ver}/tour_compare"
=======
require_relative '../forms/tourResult_form'

class CheckToursFromAPI
  def initialize(api, params_h)
    @request_url = "#{api.api_server}/#{api.api_ver}/tours"
>>>>>>> 34c61ce06f2566a3a96a292d35a4c405fccf9aa6
    @options =  { body: params_h.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    result = HTTParty.post(@request_url, @options)
<<<<<<< HEAD
    tours_result = TourCompareResults.new
    tours_result.code = result.code
    tours_result.tours = result
=======
    tours_result = ToursResult.new(result)
    tours_result.code = result.code
>>>>>>> 34c61ce06f2566a3a96a292d35a4c405fccf9aa6
    tours_result
  end
end
