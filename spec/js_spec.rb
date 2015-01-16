require_relative 'spec_helper'

feature "javascript", js: true do
  it "should have a localize_dates.js" do
    visit '/blog/localize_dates.js'
    expect(page.status_code).to be(200)
  end

  it "should localize dates" do
    visit '/2014/12/12/twelve'
    expect(page).to have_selector 'section header h2', text: '12/13/2014'
    expect(page).to have_selector 'section header time', count: 2
    expect(page).to have_selector 'time', text: '12:12:12 PM'
    expect(page).to have_selector 'time', text: '12:12:12 AM'
  end

  it "should have a comment_form.js" do
    visit '/blog/comment_form.js'
    expect(page.status_code).to be(200)
  end

  it "should remember me" do
    visit '/2014/07/07/seven'
    expect(page).to have_field 'name', with: ''
    expect(page).to have_field 'email', with: ''
    expect(page).to have_field 'url', with: ''


    within '#comment-form' do
      fill_in 'name', with: 'John Smith'
      fill_in 'email', with: 'johnsmith@example.com'
      fill_in 'url', with: 'http://example.com/'

      expect(page).to have_button 'Preview', disabled: true
      fill_in 'comment', with: 'text'
      expect(page).to have_button 'Preview', disabled: false

      check 'rememberMe'
    end

    click_button 'Preview'
    expect(page).to have_field 'name', with: 'John Smith'

    visit '/2014/07/07/seven'
    expect(page).to have_field 'name', with: 'John Smith'
    expect(page).to have_field 'email', with: 'johnsmith@example.com'
    expect(page).to have_field 'url', with: 'http://example.com/'

    click_button 'Clear Info'
    expect(page).to have_field 'name', with: ''
    expect(page).to have_field 'email', with: ''
    expect(page).to have_field 'url', with: ''

    visit '/2014/07/07/seven'
    expect(page).to have_field 'name', with: ''
    expect(page).to have_field 'email', with: ''
    expect(page).to have_field 'url', with: ''
  end
end
