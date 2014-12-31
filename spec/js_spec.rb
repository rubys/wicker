require_relative 'spec_helper'

feature "javascript", js: true do
  it "should have a jq_localize_dates.js" do
    visit '/js/jq_localize_dates.js'
    expect(page.status_code).to be(200)
  end

  it "should localize dates" do
    visit '/2014/12/12/twelve'
    expect(page).to have_selector 'time', text: '12:12:12'
  end
end
