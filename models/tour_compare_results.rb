require 'virtus'

class ResultsObjects
  include Virtus.model

  attribute :country, String
  attribute :count, Integer
  attribute :tours
end

class TourCompareResults
  include Virtus.model

  attribute :code, Integer
  attribute :tours, Array[ResultsObjects]

  def to_json
    to_hash.to_json
  end
end
