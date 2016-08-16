# Register sample applications for the Doorkeeper OAuth2 provider

nomis = Doorkeeper::Application.create!(
  name: 'NOMIS',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

pvb = Doorkeeper::Application.create!(
  name: 'Prison Visits Booking',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

mtp = Doorkeeper::Application.create!(
  name: 'Money to Prisoners',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

mps = Doorkeeper::Application.create!(
  name: 'Moving People Safely',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

# Admin user

User.create!(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  role: 'admin'
)

# Staff user

User.create!(
  email: 'staff@example.com',
  password: ENV['ADMIN_PASSWORD'],
  password_confirmation: ENV['ADMIN_PASSWORD'],
  role: 'staff'
)

# Sample Prisoner records
#
# p = Prisoner.create!(
#   given_name: 'John',
#   surname: 'Smith',
#   offender_id: '1',
#   noms_id: 'A1234AA',
#   date_of_birth: '19911010'
# )
# p.aliases.build(name: 'Johnny')
# p.save!
#
# Prisoner.create!(
#   given_name: 'Bob',
#   surname: 'Jones',
#   offender_id: '2',
#   noms_id: 'A1234AB',
#   date_of_birth: '19810304'
# )
#
# Prisoner.create!(
#   given_name: 'Keith',
#   surname: 'Johnson',
#   offender_id: '3',
#   noms_id: 'A1234AC',
#   date_of_birth: '19760821'
# )
