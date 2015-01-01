require_relative 'spec_helper'

feature "index" do
  it "should show 10 items in reverse chronological order" do
    visit '/'
    expect(page).to have_selector 'h3', count: 10

    times = page.all('article time').map {|time| time['datetime']}
    expect(times.length).to be(10)
    expect(times).to eq(times.sort.reverse)
  end

  it "should show full text for first item" do
    visit '/'
    expect(page).to have_selector 'p', text: (%w(twelve)*12).join(' ')
    expect(page).to have_xpath '//a[@href="2014/12/12/twelve"]'
    expect(page).to have_selector 'a', text: '12 comments'
  end

  it "should only have excerpts for the other items" do
    visit '/'
    expect(page).to have_selector 'p', text: /\Aeleven eleven eleven\Z/
    expect(page).to have_selector 'p', text: /\Athree three three\Z/
    expect(page).to have_selector 'a', text: 'Add comment'
    expect(page).to have_selector 'a', text: /\A1 comment\Z/
  end
end
