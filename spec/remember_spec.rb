require_relative 'spec_helper'

feature "remember me" do
  it "should remember you as you preview a comment without js" do
    visit '/blog/2014/07/07/seven'
    expect(find_field('name').value).to be_nil
    expect(find_field('email').value).to be_nil
    expect(find_field('url').value).to be_nil
    fill_in 'name', with: 'John'
    fill_in 'email', with: 'john@example.com'
    fill_in 'url', with: 'http://example.com'
    click_button 'Preview'
    expect(page).to have_field('name', with: 'John')
    expect(page).to have_field('email', with: 'john@example.com')
    expect(page).to have_field('url', with: 'http://example.com')
    click_button 'Edit'
    expect(page).to have_field('name', with: 'John')
    expect(page).to have_field('email', with: 'john@example.com')
    expect(page).to have_field('url', with: 'http://example.com')
  end

  it "should remember you across visits with js", js: true do
    visit '/blog/2014/07/07/seven'
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

    visit '/blog/2014/07/07/seven'
    expect(page).to have_field 'name', with: 'John Smith'
    expect(page).to have_field 'email', with: 'johnsmith@example.com'
    expect(page).to have_field 'url', with: 'http://example.com/'

    click_button 'Clear Info'
    expect(page).to have_field 'name', with: ''
    expect(page).to have_field 'email', with: ''
    expect(page).to have_field 'url', with: ''

    visit '/blog/2014/07/07/seven'
    expect(page).to have_field 'name', with: ''
    expect(page).to have_field 'email', with: ''
    expect(page).to have_field 'url', with: ''
  end
end
