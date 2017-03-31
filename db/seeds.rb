# Register sample applications for the Doorkeeper OAuth2 provider
nomis = Doorkeeper::Application.find_or_create_by!(
  name: 'NOMIS',
  redirect_uri: "https://#{ENV['HTTP_HOST']}",
  scopes: 'public write'
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

# Import nicknames
file = Rails.root.join('db', 'nicknames.csv')
ParseNicknames.call(file.read)
