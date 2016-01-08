require 'virtus'
require 'json'


class TourCompareResults
  include Virtus.model

  attribute :code, Integer
  attribute :series
  attribute :drilldown
  attribute :categories, Array[]
  attribute :countries, Array[]
  attribute :tours

  def to_json
    to_hash.to_json
  end
end
