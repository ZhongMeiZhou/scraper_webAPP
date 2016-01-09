require 'page-object'

class DashboardPage
  include PageObject

  page_url 'http://localhost:3000'

  # define filter elements
  select_list(:countries, :id => 'tour_countries')
  select_list(:categories, :id => 'tour_categories')
  text_field(:price, :id => 'inputPriceRange')
  div(:chart, :id => 'container')
  div(:tours, :id => 'tours')
  h2(:num_tours, :id => 'num_tours')
  button(:submit, id: 'submit')

  def generate_results(countries, categories)
  	self.countries = countries
  	self.categories = categories
  	submit
  	chart_check(self.chart)
    tour_check(self.tours)
  end

  # check that the title is found somewhere in the div since the chart will have a legend of country names in the div
  def chart_check(chart)
    chart.must_match(/Belize/i)
  end

  def tour_check(tour)
    tour.must_match(/found/i)
  end
end
