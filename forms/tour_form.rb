require 'virtus'
require 'active_model'
require 'json'

class TourForm
  include Virtus.model
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  attribute :tour_countries, String
  attribute :tour_categories, String
  attribute :inputPriceRange, String

  validates :tour_countries, presence: true
  #validates :tour_categories, presence: true

  def error_fields
    errors.messages.keys.map(&:to_s).join(', ')
  end
end
