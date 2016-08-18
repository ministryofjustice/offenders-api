FROM ministryofjustice/ruby:2.3.0-webapp-onbuild

EXPOSE 3000

RUN RAILS_ENV=production SECRET_KEY_BASE=a-real-secret-key-is-not-needed-here bundle exec rake assets:precompile swagger:docs

RUN RAILS_ENV=production bin/rake --trace

CMD ["./run.sh"]
