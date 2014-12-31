require_relative 'spec_helper'

feature "entry" do

  it "show full text" do
    visit '/2014/12/12/twelve'
    expect(page).to have_selector 'p', text: (%w(twelve)*12).join(' ')
  end
end
