require 'httparty'
require 'json'
require_relative '../forms/tour_form'

module WebAppHelper
	
	def post_api_tour (country, request_url)
		submit = TourForm.new
    		submit.country = country

		if submit.valid? == false
			{ :status => false, :message => 'You broke it!' }
    		else
    			options = {
      				body: submit.to_json,
      				headers: { 'Content_Type' => 'application/json'}
    			}
    			begin
        			results = HTTParty.post(request_url, options)

      			rescue StandardError => e
        			logger.info e.message
        			halt 400, e.message
      			end		
    			if (results.code != 200)
				{ :status => false, :message => "The Pony Express did not deliver the goods." }
    			else 
	    			id = results.request.last_uri.path.split('/').last
				{ :status => true, :result => results.to_json, :id => id }
			end
		end
	end

	def get_api_tours (url)
      		options = { headers: { 'Content-Type' => 'application/json'}}
      		begin
        		@results = HTTParty.get(url,options)
      		rescue StandardError => e
        		logger.info e.message
        		halt 400, e.message
      		end
	end
end

