require_relative 'spec_helper'

feature "preview" do
  it "should allow you to preview a comment without js" do
    visit '/blog/2014/07/07/seven'
    fill_in 'comment', with: '*text*'
    click_button 'Preview'
    expect(page).to have_selector 'em', text: 'text'
    expect(page).to have_selector 'textarea[@readonly]', text: '*text*'
    expect(page).to have_selector 'h2', text: 'Preview your comment'
    expect(page).to have_selector 'input[value=Edit]'
    expect(page).to have_selector 'input[value=Submit]'
    click_button 'Edit'
    expect(page).to have_selector 'em', text: 'text'
    expect(page).to have_selector 'textarea', text: '*text*'
    expect(page).to have_selector 'h2', text: 'Edit your comment'
    expect(page).to have_selector 'input[value=Preview]'
    expect(page).to_not have_selector 'input[value=Submit]'
    fill_in 'comment', with: '*text2*'
    click_button 'Preview'
    expect(page).to have_selector 'em', text: 'text2'
    expect(page).to have_selector 'textarea[@readonly]', text: '*text2*'
    expect(page).to have_selector 'h2', text: 'Preview your comment'
    expect(page).to have_selector 'input[value=Edit]'
    expect(page).to have_selector 'input[value=Submit]'
  end

  it "should allow you to preview a comment with js", js: true do
    visit '/blog/2014/07/07/seven'
    expect(page).to have_button 'Preview', disabled: true
    fill_in 'comment', with: '*text*'
    click_button 'Preview'
    expect(page).to have_selector 'em', text: 'text'
    expect(page).to have_selector 'textarea', text: '*text*'
    expect(page).to have_selector 'h2', text: 'Edit your comment'
    expect(page).to_not have_selector 'input[value=Edit]'
    expect(page).to have_selector 'input[value=Submit]'
    fill_in 'comment', with: '*text2*'
    expect(page).to have_selector 'input[value=Preview]'
    fill_in 'comment', with: '*text*'
    expect(page).to have_selector 'input[value=Submit]'
    fill_in 'comment', with: '*text2*'
    click_button 'Preview'
    expect(page).to have_selector 'em', text: 'text2'
    expect(page).to have_selector 'textarea', text: '*text2*'
    expect(page).to have_selector 'h2', text: 'Edit your comment'
    expect(page).to_not have_selector 'input[value=Edit]'
    expect(page).to have_selector 'input[value=Submit]'
  end
end
