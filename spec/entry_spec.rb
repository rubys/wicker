require_relative 'spec_helper'

feature "entry" do
  it "should show an entry with associated comments in chronological order" do
    visit '/2014/12/12/twelve'
    expect(page).to have_selector 'p', text: (%w(twelve)*12).join(' ')
    expect(page).to have_selector 'section article', count: 12
    expect(page).to have_selector 'section', count: 2
    expect(page).to have_selector 'section header h2', text: '2014-12-13'
    expect(page).to have_selector 'section header h2', text: '2014-12-12'
    expect(page).to have_xpath '//article[@id="c1418447532"]'
    expect(page).to have_xpath '//a[@href="#c1418447532"]'

    times = page.all('article time').map {|time| time['datetime']}
    expect(times.length).to be(13)
    expect(times).to eq(times.sort)
  end
end
