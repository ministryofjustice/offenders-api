[![Build Status](https://travis-ci.org/ministryofjustice/prisoners-api.svg?branch=master)](https://travis-ci.org/ministryofjustice/prisoners_api)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/prisoners_api/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/prisoners_api/coverage)

# Offenders API

Initial Offenders API microservice Rails app. Set up with Doorkeeper OAuth2 provider for [two-legged](https://github.com/doorkeeper-gem/doorkeeper/wiki/Client-Credentials-flow) auth.

Instructions:

`HTTP_HOST=localhost:3000 ADMIN_EMAIL=example@example.com ADMIN_PASSWORD=password123 rake db:create db:migrate db:seed`

Replace `ADMIN_EMAIL` and `ADMIN_PASSWORD` with preferred values.

To import sample records:

`rake import:sample`

Navigate to http://localhost:3000

Sign in with:

Email: example@example.com

Password: password123

Select one of the sample applications and click "Get access token." The returned JSON contains the access token.

Once the access token has been obtained you can make requests to `/api/offenders` (to get a list of all offenders), `/api/offenders/search` with params to search offenders, `/api/offenders/<ID>` to get a specific offender. The access token should be passed either in the header or as a request params.

e.g:

```
http://localhost:3000/api/offenders?page=1&per_page=10&access_token=<ACCESS TOKEN>
http://localhost:3000/api/offenders/search?noms_id=A1403AE&surname=smith&access_token=<ACCESS TOKEN>
http://localhost:3000/api/offenders/<PRISONER ID>?access_token=<ACCESS TOKEN>
```

You can find a offender ID by opening the Rails console, e.g:

```
$ rails c
2.3.0 :001 > Offender.first.id
 => "0029d940-a835-418a-af7d-37e7cd6edd10"
```

You can access the Swagger documentation at:

```
http://localhost:3000/api-docs
```

To create a offender record using Curl:

```
curl -v -H "Authorization: Bearer <ACCESS TOKEN>" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{ "offender" : { "noms_id" : "1234", "given_name" : "John", "surname" : "Smith", "date_of_birth" : "19800101", "gender" : "M" } }'  http://localhost:3000/api/offenders
```

An accept header containing the API version can be passed, currently this defaults to version 1 if nothing is passed.
