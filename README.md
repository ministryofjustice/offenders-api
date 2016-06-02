# Prisoners API

Initial Prisoners API microservice Rails app. Set up with Doorkeeper OAuth2 provider for [two-legged](https://github.com/doorkeeper-gem/doorkeeper/wiki/Client-Credentials-flow) auth.

Instructions:

`rake db:create db:migrate db:seed`

Navigate to http://localhost:3000

Select one of the sample applications and click "Authorise"

The returned authorisation code can be used to obtain an access token. Curl request:

`curl --data "client_id=<APPLICATION_ID>&client_secret=<APPLICATION_SECRET>&code=<AUTH_CODE>&grant_type=authorization_code&redirect_uri=http://localhost:3000" http://localhost:3000/oauth/token`

Where APPLICATION\_ID and APPLICATION\_SECRET can be taken from the Client ID and Secret columns from the table of services on the home page.

Once the access token has been obtained you can make requests to the `/prisoners` and `/prisoners/<ID>` endpoints passing the access token as a header or request param.
