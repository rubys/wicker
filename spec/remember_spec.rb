require_relative 'spec_helper'

feature "remember me" do
  it "should remember you as you preview a comment without js" do
    visit '/2014/07/07/seven'
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
    visit '/2014/07/07/seven'
    expect(find_field('name').value).to eq('')
    expect(find_field('email').value).to eq('')
    expect(find_field('url').value).to eq('')
    fill_in 'name', with: 'John'
    fill_in 'email', with: 'john@example.com'
    fill_in 'url', with: 'http://example.com'
    fill_in 'comment', with: 'text'
    check 'rememberMe'
    click_button 'Preview'
    visit '/2014/07/07/seven'
    expect(page).to have_field('name', with: 'John')
    expect(page).to have_field('email', with: 'john@example.com')
    expect(page).to have_field('url', with: 'http://example.com')
    click_button 'Clear Info'
    visit '/2014/07/07/seven'
    expect(find_field('name').value).to eq('')
    expect(find_field('email').value).to eq('')
    expect(find_field('url').value).to eq('')
  end
end
