FROM ministryofjustice/ruby:2.3.0-webapp-onbuild

EXPOSE 3000

RUN RAILS_ENV=production bin/rake --trace

ENTRYPOINT ["./run.sh"]
