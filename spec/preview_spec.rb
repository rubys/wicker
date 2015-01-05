require_relative 'spec_helper'

feature "entry" do
  it "should show an entry with associated comments in chronological order" do
    visit '/2014/07/07/seven'
    fill_in 'comment', with: '*text*'
    click_button 'Preview'
    expect(page).to have_selector 'em', text: 'text'
    expect(page).to have_selector 'textarea', text: '*text*'
    expect(page).to have_selector 'h2', text: 'Edit your comment'
  end
end
