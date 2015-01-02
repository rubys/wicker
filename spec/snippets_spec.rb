require_relative 'spec_helper'

feature "snippets" do
  it "should include watermark" do
    visit 'archives/2014/12'
    expect(page).to have_selector 'footer svg'
  end

  it "should include menu" do
    visit '/'
    expect(page).to have_selector 'footer ul li', text: 'HTTP'
  end

  it "should include sidebar" do
    visit '/'
    expect(page).to have_selector 'aside h2', text: 'mingle'
  end
end
