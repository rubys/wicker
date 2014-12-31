require_relative 'spec_helper'

feature "css" do
  it "should have a blogy.css" do
    visit '/css/blogy.css'
    expect(page.status_code).to be(200)
  end

  it "should have a print.css" do
    visit '/css/print.css'
    expect(page.status_code).to be(200)
  end
end
