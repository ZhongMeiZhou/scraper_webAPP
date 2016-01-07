require 'virtus'
require 'json'

class Json < Virtus::Attribute
  def coerce(value)
    value.is_a?(::Hash) ? value : JSON.parse(value)
  end
end

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
