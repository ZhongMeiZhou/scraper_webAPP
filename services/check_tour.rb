require 'virtus'
require 'active_model'
require_relative '../forms/tourResult_form'

class CheckToursFromAPI
  def initialize(api, params_h)
    @request_url = "#{api.api_server}/#{api.api_ver}/tours"
    @options =  { body: params_h.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    result = HTTParty.post(@request_url, @options)
    tours_result = ToursResult.new(result)
    tours_result.code = result.code
    tours_result
  end
end
