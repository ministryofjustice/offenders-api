module LoginHelper
  def login(role = 'staff')
    OauthHelper.configure_mock(role)
    visit new_session_path
    click_on 'Sign in with a Ministry of Justice Sign On account'
  end
end
