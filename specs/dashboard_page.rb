require 'page-object'

class DashboardPage
  include PageObject

  page_url 'http://localhost:3000'

  # define filter elements
  select_list(:countries, :id => 'countries')
  select_list(:categories, :id => 'categories')
  text_field(:price, :id => 'inputPriceRange')
  button(:filter, id: 'filter')

end
