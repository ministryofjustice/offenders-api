require 'rails_helper'

RSpec.feature 'Manage services', type: :feature do
  context 'when admin' do
    before { login(:admin) }

    scenario 'add a service' do
      visit new_service_path

      fill_in 'Name', with: 'NOMS'
      fill_in 'Redirect URI', with: 'https://offenders-api.com'

      click_button 'Add'

      expect(current_path).to eq services_path

      within('table') do
        expect(page).to have_content('NOMS')
      end
    end

    scenario 'modify a service' do
      create(:application)

      visit services_path

      click_link 'Edit'

      fill_in 'Name', with: 'NOMS Modified'
      fill_in 'Scopes', with: 'write read'
      fill_in 'Redirect URI', with: 'https://new_url_offenders-api.com'

      click_button 'Update'

      within('table') do
        expect(page).to have_content('NOMS Modified')
      end
    end

    scenario 'show a service' do
      application = create(:application, name: 'NOMS', redirect_uri: 'https://nomis.com', scopes: 'public write')

      visit services_path

      click_link 'Show'

      expect(page).to have_content('Service: NOMS')
      expect(page).to have_content('Redirect URI: https://nomis.com')
      expect(page).to have_content("Client ID: #{application.uid}")
      expect(page).to have_content("Client secret: #{application.secret}")
    end

    scenario 'destroy a service' do
      create(:application, name: 'NOMS')

      visit services_path

      click_link 'Destroy'

      within('table') do
        expect(page).to_not have_content('NOMS')
      end
    end
  end

  context 'when staff' do
    scenario 'not authorized' do
      login(:staff)

      visit services_path

      expect(current_path).to eq new_import_path
    end
  end
end
