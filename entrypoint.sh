#!/bin/bash
errbit_env(){
  echo export RAILS_ENV="$RAILS_ENV"
  echo export RACK_ENV="$RACK_ENV"
  echo export PORT="$PORT"
  echo export UNICORN_PID="$UNICORN_PID"
  echo export BRANCH=${BRANCH:-master}

  echo export ERRBIT_HOST="$ERRBIT_HOST"
  echo export ERRBIT_PROTOCOL="$ERRBIT_PROTOCOL"
  echo export ERRBIT_PORT="$ERRBIT_PORT"
  echo export ERRBIT_ENFORCE_SSL="$ERRBIT_ENFORCE_SSL"
  echo export ERRBIT_CONFIRM_ERR_ACTIONS="$ERRBIT_CONFIRM_ERR_ACTIONS"
  echo export ERRBIT_USER_HAS_USERNAME="$ERRBIT_USER_HAS_USERNAME"
  echo export ERRBIT_USE_GRAVATAR="$ERRBIT_USE_GRAVATAR"
  echo export ERRBIT_GRAVATAR_DEFAULT="$ERRBIT_GRAVATAR_DEFAULT"
  echo export ERRBIT_EMAIL_FROM="$ERRBIT_EMAIL_FROM"
  echo export ERRBIT_EMAIL_AT_NOTICES="$ERRBIT_EMAIL_AT_NOTICES"
  echo export ERRBIT_PER_APP_EMAIL_AT_NOTICES="$ERRBIT_PER_APP_EMAIL_AT_NOTICES"
  echo export ERRBIT_NOTIFY_AT_NOTICES="$ERRBIT_NOTIFY_AT_NOTICES"
  echo export ERRBIT_PER_APP_NOTIFY_AT_NOTICES="$ERRBIT_PER_APP_NOTIFY_AT_NOTICES"

  echo export SERVE_STATIC_ASSETS="$SERVE_STATIC_ASSETS"
  echo export SECRET_KEY_BASE="$SECRET_KEY_BASE"
  echo export MONGODB_URL="$MONGODB_URL"

  # github
  echo export GITHUB_URL="$GITHUB_URL"
  echo export GITHUB_AUTHENTICATION="$GITHUB_AUTHENTICATION"
  echo export GITHUB_CLIENT_ID="$GITHUB_CLIENT_ID"
  echo export GITHUB_SECRET="$GITHUB_SECRET"
  echo export GITHUB_ORG_ID="$GITHUB_ORG_ID"
  echo export GITHUB_ACCESS_SCOPE="$GITHUB_ACCESS_SCOPE"

  echo export EMAIL_DELIVERY_METHOD="$EMAIL_DELIVERY_METHOD"

  # smtp settings
  echo export SMTP_SERVER="$SMTP_SERVER"
  echo export SMTP_PORT="$SMTP_PORT"
  echo export SMTP_AUTHENTICATION="$SMTP_AUTHENTICATION"
  echo export SMTP_USERNAME="$SMTP_USERNAME"
  echo export SMTP_PASSWORD="$SMTP_PASSWORD"
  echo export SMTP_DOMAIN="$SMTP_DOMAIN"

  # sendmail settings
  echo export SENDMAIL_LOCATION="$SENDMAIL_LOCATION"
  echo export SENDMAIL_ARGUMENTS="$SENDMAIL_ARGUMENTS"

  echo export DEVISE_MODULES="$DEVISE_MODULES"
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
