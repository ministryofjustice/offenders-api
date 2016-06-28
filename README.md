[![Build Status](https://travis-ci.org/ministryofjustice/prisoners_api.svg?branch=master)](https://travis-ci.org/ministryofjustice/prisoners_api)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api/coverage)

[![Code Climate](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api)

[![Test Coverage](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api/coverage)

# Prisoners API

Initial Prisoners API microservice Rails app. Set up with Doorkeeper OAuth2 provider for [two-legged](https://github.com/doorkeeper-gem/doorkeeper/wiki/Client-Credentials-flow) auth.

Instructions:

`rake db:create db:migrate db:seed`

Navigate to http://localhost:3000

Sign in with:

example@example.com
password

Select one of the sample applications and click "Get access token." The returned JSON contains the access token.

Once the access token has been obtained you can make requests to the `/prisoners` and `/prisoners/<ID>` endpoints passing the access token in the header or as a request param.
