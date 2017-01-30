#!/bin/bash
export RAILS_ENV=production
cd /usr/src/app
case ${DOCKER_STATE} in
create)
    echo "running create"
    bundle exec rails db:setup db:seed
    ;;
migrate_and_seed)
    echo "running migrate and seed"
    bundle exec rails db:migrate db:seed
    ;;
drop_and_create)
    echo "running drop and create"
    bundle exec rails db:drop db:setup db:seed
    ;;
esac

whenever --update-crontab

/usr/bin/redis-server --daemonize yes
bundle exec sidekiq -d -L log/sideqik.log

ruby bin/rails server -d --binding 0.0.0.0
tail -f /usr/src/app/log/*
