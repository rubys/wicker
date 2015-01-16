require_relative 'spec_helper'

feature "javascript", js: true do
  it "should have a localize_dates.js" do
    visit '/blog/localize_dates.js'
    expect(page.status_code).to be(200)
  end

  it "should localize dates" do
    visit '/blog/2014/12/12/twelve'
    expect(page).to have_selector 'section header h2', text: '12/13/2014'
    expect(page).to have_selector 'section header time', count: 2
    expect(page).to have_selector 'time', text: '12:12:12 PM'
    expect(page).to have_selector 'time', text: '12:12:12 AM'
  end

  it "should have a comment_form.js" do
    visit '/blog/comment_form.js'
    expect(page.status_code).to be(200)
  end
end
