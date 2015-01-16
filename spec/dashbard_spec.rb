require_relative 'spec_helper'

feature "update", js: true do
  it "should update all pages" do
    visit '/dashboard'
    expect(page).to have_select 'pages', selected: 'index.html'
    click_button 'Update'
    expect(page).to have_select 'pages', selected: '2014/12/12/twelve'
  end
end
