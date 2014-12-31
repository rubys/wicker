require_relative 'spec_helper'

feature "index" do
  it "should show 10 items" do
    visit '/'
    expect(page).to have_selector 'h3', count: 10
  end

  it "should show full text for first item" do
    visit '/'
    expect(page).to have_selector 'p', text: (%w(twelve)*12).join(' ')
    expect(page).to have_xpath '//a[@href="2014/12/12/twelve"]'
    expect(page).to have_selector 'a', text: 'Add comment'
  end

  it "should only have excerpts for the other items" do
    visit '/'
    expect(page).to have_selector 'p', text: /\Aeleven eleven eleven\Z/
    expect(page).to have_selector 'p', text: /\Athree three three\Z/
  end
end
