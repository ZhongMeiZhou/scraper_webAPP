require 'virtus'
require 'active_model'
require '../forms/tourResult_form'

class CheckToursFromAPI
  def initialize(api, params_h)
    @request_url = "#{api.api_server}/#{api.api_ver}/tours"
    @options =  { body: params_h.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    result = HTTParty.post(@request_url, @options)
    puts result
    tours_result = TourResult.new(result)
    tours_result.code = result.code
    #tours_result.id =  result.request.last_uri.path.split('/').last
    tours_result
  end
end
