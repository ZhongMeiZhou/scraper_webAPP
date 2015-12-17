require 'virtus'

#class ResultsObjects
  #include Virtus.model

  #attribute :country, String
  #attribute :data, Array[]
#end

class TourCompareResults
  include Virtus.model

  attribute :code, Integer
  attribute :data, Array[]

  def to_json
    to_hash.to_json
  end
end
