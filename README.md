# Prisoners API

Initial Prisoners API microservice Rails app. Set up with Doorkeeper OAuth2 provider for [two-legged](https://github.com/doorkeeper-gem/doorkeeper/wiki/Client-Credentials-flow) auth.

Instructions:

`rake db:create db:migrate db:seed`

Navigate to http://localhost:3000

Select one of the sample applications and click "Get access token." The returned JSON contains the access token.

Once the access token has been obtained you can make requests to the `/prisoners` and `/prisoners/<ID>` endpoints passing the access token in the header or as a request param.
