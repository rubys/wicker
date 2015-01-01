require_relative 'spec_helper'

feature "entry" do
  it "show full text" do
    visit '/2014/12/12/twelve'
    expect(page).to have_selector 'p', text: (%w(twelve)*12).join(' ')
    expect(page).to have_selector 'section article', count: 12
    expect(page).to have_selector 'section', count: 2
    expect(page).to have_selector 'section header h2', text: '2014-12-13'
    expect(page).to have_selector 'section header h2', text: '2014-12-12'
  end
end
