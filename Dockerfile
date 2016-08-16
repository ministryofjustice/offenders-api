FROM ministryofjustice/ruby:2.3.0-webapp-onbuild

EXPOSE 3000

RUN bundle exec rake swagger:docs

RUN RAILS_ENV=production bin/rake --trace

CMD ["./run.sh"]
