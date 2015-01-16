require_relative 'spec_helper'

feature "css" do
  it "should have a screen.css" do
    visit '/blog/screen.css'
    expect(page.status_code).to be(200)
  end

  it "should have a print.css" do
    visit '/blog/print.css'
    expect(page.status_code).to be(200)
  end
end
