require_relative 'spec_helper'

feature "entry" do
  it "should show an entry with associated comments in chronological order" do
    visit '/blog/2014/12/12/twelve'

    # time of last comment
    ctime = Time.new(2014,12,12,12,12,12).to_i + 12*60*60

    expect(page).to have_selector 'p', text: (%w(twelve)*12).join(' ')
    expect(page).to have_xpath '//section/article[@id]', count: 12
    expect(page).to have_selector 'section h2 time', count: 2
    expect(page).to have_selector 'section header h2', text: '2014-12-13'
    expect(page).to have_selector 'section header h2', text: '2014-12-12'
    expect(page).to have_xpath "//article[@id='c#{ctime}']"
    expect(page).to have_xpath "//a[@href='#c#{ctime}']"
    expect(page).to have_xpath '//a[@id="comments"]'
    expect(page).to have_selector 'h2', text: 'Add your comment'
    expect(page).to have_selector 'textarea#comment'
    expect(page).to have_xpath '//input[@type="submit" and @value="Preview"]'

    times = page.all('article time').map {|time| time['datetime']}
    expect(times.length).to be(13)
    expect(times).to eq(times.sort)
  end
end
