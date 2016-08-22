# Register sample applications for the Doorkeeper OAuth2 provider

nomis = Doorkeeper::Application.find_or_create_by!(
  name: 'NOMIS',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

pvb = Doorkeeper::Application.find_or_create_by!(
  name: 'Prison Visits Booking',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

mtp = Doorkeeper::Application.find_or_create_by!(
  name: 'Money to Prisoners',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

mps = Doorkeeper::Application.find_or_create_by!(
  name: 'Moving People Safely',
  redirect_uri: "https://#{ENV['HTTP_HOST']}"
)

# Admin user

unless User.find_by(email: ENV['ADMIN_EMAIL'])
  User.create!(
    email: ENV['ADMIN_EMAIL'],
    password: ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN_PASSWORD'],
    role: 'admin'
  )
end

# Staff user

unless User.find_by(email: 'staff@example.com')
  User.create!(
    email: 'staff@example.com',
    password: ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN_PASSWORD'],
    role: 'staff'
  )
end

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
