# Register sample applications for the Doorkeeper OAuth2 provider

pvb = Doorkeeper::Application.create!(
  name: 'Prison Visits Booking',
  redirect_uri: 'http://localhost:3000'
)

mtp = Doorkeeper::Application.create!(
  name: 'Money to Prisoners',
  redirect_uri: 'http://localhost:3000'
)

mps = Doorkeeper::Application.create!(
  name: 'Moving People Safely',
  redirect_uri: 'http://localhost:3000'
)

# Default admin user

User.create!(email: 'example@example.com', password: 'password', password_confirmation: 'password')

# Sample Prisoner records

Prisoner.create!(given_name: 'John', surname: 'Smith')
Prisoner.create!(given_name: 'Bob', surname: 'Jones')
Prisoner.create!(given_name: 'Keith', surname: 'Johnson')
