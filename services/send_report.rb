require 'json'
class SendReport
  def initialize(api, email, result)
    @request_url = "#{api.api_server}/#{api.api_ver}/send_email"
    @options =  { body: {
                    email: email,
                    result: result
                  }.to_json,
                  headers: { 'Content-Type' => 'application/json' }
                }
  end

  def call
    result = HTTParty.post(@request_url, @options)
  end
end