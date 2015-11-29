require_relative 'spec_helper'

describe 'Tour Stories' do 
  before do
  	unless @browser
  	  @headless = Headless.new
  	  @browser = Watir::Browser.new
  	end
  	@browser.goto 'http://localhost:3000'
  end

  describe 'Visiting HomePage' do
  	it 'finds the title' do
  	  @browser.title.must_equal 'ZmZ'
  	end
  end

  describe 'Tour Search' do
    it 'can search for a tour' do
      @browser.text_field(name: 'tour').set('belize')

      @browser.button(id: 'btn_search').click

      @browser.table(class: 'table table-striped').rows.count.must_be :>=, 3
    end
  end

  #after do
  	#@browser.close
  	#@headless.destroy
  #end
end
