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

# Import nicknames
file = Rails.root.join('db', 'nicknames.csv')
ParseNicknames.call(file.read)
