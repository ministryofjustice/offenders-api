FROM ministryofjustice/ruby:2.3.0-webapp-onbuild

EXPOSE 3000

RUN apt-get update && apt-get install -y redis-server cron && apt-get clean

EXPOSE 6379

RUN RAILS_ENV=production SECRET_KEY_BASE=a-real-secret-key-is-not-needed-here bundle exec rails assets:precompile

RUN RAILS_ENV=production bin/rake --trace

CMD ["./run.sh"]
