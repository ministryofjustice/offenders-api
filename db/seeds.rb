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
