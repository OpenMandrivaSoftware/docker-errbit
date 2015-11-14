#!/bin/bash
errbit_env(){
  echo export RAILS_ENV=${RAILS_ENV:-production}
  echo export RACK_ENV=${RACK_ENV:-production}
  echo export PORT=${PORT:-3000}
  echo export BRANCH=${BRANCH:-master}
}

prepare_repo(){
  echo "prepare Errbit environment vars"
  errbit_env >> /app/envfile
  echo "apply updated env file"
  source /app/envfile
  if [ ! -d "/app/errbit" ]; then
    git clone https://github.com/OpenMandrivaSoftware/errbit.git -b $BRANCH /app/errbit
  fi
  pushd /app/errbit
  gem install bundler
  bundle install --without development test --jobs 20 --retry 5
  echo "update styles"
  rake assets:precompile
  popd
}
prepare_repo
pushd /app/errbit
bundle exec unicorn -c config/unicorn.default.rb
popd
