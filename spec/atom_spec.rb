require_relative 'spec_helper'

feature "feed" do
  it "should include 10 entries" do
    visit '/blog/index.atom'
    expect(page).to have_selector 'entry', count: 10
  end

  it "should have entry ids, links, titles, and updated dates" do
    visit '/blog/index.atom'
    expect(page).to have_selector 'entry id', 
      text: 'tag:intertwingly.net,2004:seven'
    expect(page).to have_selector 'entry title', text: 'Seven'
    expect(page).to have_xpath '//entry/link[@href="2014/07/07/seven"]'
    expect(page).to have_selector 'entry updated', text: '2014-07-07T07:07:07'
  end

  it "should have summaries and full text" do
    visit '/blog/index.atom'
    expect(page).to have_selector 'summary p', text: /\Atwelve twelve twelve\Z/
    expect(page).to have_selector 'content p', text: (%w(twelve)*12).join(' ')
  end
end
