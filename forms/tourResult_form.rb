require 'virtus'

class ToursResult
  include Virtus.model

  attribute :id
  attribute :country
  attribute :tours


  def to_json
    to_hash.to_json
  end
end
