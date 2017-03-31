module OauthHelper
  def configure_mock(role = 'staff')
    OmniAuth.config.add_mock(:mojsso, auth_hash(role))
  end

  def auth_hash(role)
    {
      'provider': 'mojsso',
      'uid': '1234',
      'info': {
        "id": 1,
        "email": 'example@some.prison.com',
        "first_name": 'Joe',
        "last_name": 'Bloggs',
        "permissions": [{ 'organisation' => 'digital.noms.moj', 'roles' => [role] }],
        "links": {
          "profile": 'https://some-sso.biz/profile',
          "logout": 'http://some-sso.biz/users/sign_out'
        }
      },
      'credentials': {
        'token': 'mock-token',
        'secret': 'mock-secret'
      }
    }
  end

  module_function :configure_mock, :auth_hash
end
