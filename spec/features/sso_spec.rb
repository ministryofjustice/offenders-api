require 'rails_helper'

RSpec.feature 'SSO integration', type: :feature do
  before do
    OauthHelper.configure_mock
  end

  scenario 'authenticating a user using SSO' do
    visit root_path
    click_on 'Sign in with a Ministry of Justice Sign On account'
    expect(page).to have_button('Sign out')
  end

  scenario 'signing a user out of the app' do
    visit root_path
    click_on 'Sign in with a Ministry of Justice Sign On account'

    click_on 'Sign out'

    visit root_path
    expect(current_path).to eq new_session_path
  end

  context 'when authentication through SSO fails' do
    before do
      OmniAuth.config.mock_auth[:mojsso] = :invalid_credentials
    end

    scenario 'user is redirected to the login page' do
      visit root_path
      click_on 'Sign in with a Ministry of Justice Sign On account'
      expect(page).to have_link('Sign in with a Ministry of Justice Sign On account')
      expect(page).not_to have_button('Sign out')
    end
  end
end
