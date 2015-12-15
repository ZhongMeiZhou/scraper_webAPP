require 'virtus'

class ResultsObjects
  include Virtus.model

  attribute :country, String
  attribute :data
end

class TourCompareResults
  include Virtus.model

  attribute :code, Integer
  attribute :results, Array[ResultsObjects]

  def to_json
    to_hash.to_json
  end
end
