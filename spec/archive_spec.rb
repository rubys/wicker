require_relative 'spec_helper'

feature "archive" do
  it "should show a calendar for the month of June" do
    visit '/blog/archives/2014/06'
    expect(page).to have_selector 'div.day', count: 30
    expect(page).to have_xpath '//a[@href="../../2014/06/06/six"]'
    expect(page).to have_selector 'li a', text: 'Six'
    expect(page).to have_selector '.leftbar a', text: 'May 2014'
    expect(page).to have_selector 'caption a', text: 'June 2014'
    expect(page).to have_selector '.rightbar a', text: 'July 2014'
  end
end
