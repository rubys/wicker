require_relative 'spec_helper'

feature "pending" do
  include Rack::Test::Methods
  def app; Capybara.app; end

  it "should allow you get a list of unmoderated comments" do
    visit '/2014/06/06/six'
    fill_in 'comment', with: 'spam'
    click_button 'Preview'
    fill_in 'name', with: 'shady'
    click_button 'Submit'

    get '/2014/06/06/six/pending.json'
    pending = JSON.parse(last_response.body)
    mtime, content = pending.last
    expect(content).to include('shady')
    expect(content).to include('spam')
  end
end
