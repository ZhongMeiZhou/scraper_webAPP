require 'page-object'

class DashboardPage
  include PageObject

  page_url 'http://localhost:3000'

  # define filter elements
  select_list(:countries, :id => 'tour_countries')
  select_list(:categories, :id => 'tour_categories')
  text_field(:price, :id => 'inputPriceRange')
  div(:chart, :id => 'tour_compare')
  button(:submit, id: 'submit')

  def generate_visualization(countries, categories)
  	self.countries = countries
  	self.categories = categories
  	submit
  	result_for(self.chart)
  end

  def result_for(chart)
  	chart.must_match(/Belize/i)
  end

end
