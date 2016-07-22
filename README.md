[![Build Status](https://travis-ci.org/ministryofjustice/prisoners-api.svg?branch=master)](https://travis-ci.org/ministryofjustice/prisoners_api)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api/coverage)

# Prisoners API

Initial Prisoners API microservice Rails app. Set up with Doorkeeper OAuth2 provider for [two-legged](https://github.com/doorkeeper-gem/doorkeeper/wiki/Client-Credentials-flow) auth.

Instructions:

`ADMIN_EMAIL=example@example.com ADMIN_PASSWORD=password123 rake db:create db:migrate db:seed`

Replace `ADMIN_EMAIL` and `ADMIN_PASSWORD` with preferred values.

To import sample records:

`bundle exec rake import:sample`

Navigate to http://localhost:3000

Sign in with:

Email: example@example.com

Password: password

Select one of the sample applications and click "Get access token." The returned JSON contains the access token.

Once the access token has been obtained you can make requests to the `/api/prisoners` and `/api/prisoners/<ID>` endpoints passing the access token in the header or as a request param.

e.g:

```
http://localhost:3000/api/prisoners/0029d940-a835-418a-af7d-37e7cd6edd10?access_token=96183e17f3194cdbdd24eb8483fadab73d4778be04b77a2ca9c9b3371a2fceb6
```

You can find a prisoner id by opening a rails console e.g:

```
$ rails c
2.3.0 :001 > Prisoner.first.id
 => "0029d940-a835-418a-af7d-37e7cd6edd10"
```

An accept header containing the API version can be passed, currently this defaults to version 1 if not passed.
