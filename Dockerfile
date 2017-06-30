FROM ministryofjustice/ruby:2.3.1-webapp-onbuild

EXPOSE 3000

RUN apt-get update && apt-get install -y redis-server cron && apt-get clean

EXPOSE 6379

RUN RAILS_ENV=production SKIP_OPTIONAL_INITIALIZERS=true SECRET_KEY_BASE=a-real-secret-key-is-not-needed-here bundle exec rails assets:precompile

CMD ["./run.sh"]
