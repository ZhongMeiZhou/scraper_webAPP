require 'virtus'
require 'json'


class TourCompareResults
  include Virtus.model

  attribute :code, Integer
  attribute :series
  attribute :drilldown
  attribute :filtered_categories, Array[]
  attribute :all_categories, Array[]
  attribute :tours



  def to_json
    to_hash.to_json
  end
end
