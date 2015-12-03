require_relative 'spec_helper'
require_relative 'dashboard_page'
require 'page-object'

describe 'Tour Stories' do 
  include PageObject::PageFactory

  before do
  	unless @browser
  	  @headless = Headless.new
  	  @browser = Watir::Browser.new
  	end
  end

  describe 'Visiting Dashboard' do
  	it 'finds the title and check dropdowns' do
      visit DashboardPage do |page|
        page.title.must_equal 'ZmZ TraViz'
        page.countries_options.size.must_be :>=, 1
        page.categories_options.size.must_be :>=, 1
      end
  	end
  end

  # future revision
  #describe 'Tour Search' do
    #it 'can search for a tour' do
      #@browser.text_field(name: 'tour').set('belize')

      #@browser.button(id: 'btn_search').click

      #@browser.table(class: 'table table-striped').rows.count.must_be :>=, 3
    #end
  #end

  #causes crash
  #after do
  	#@browser.close
  	#@headless.destroy
  #end
end
