FROM ruby:2.3

RUN mkdir -p /flan-api
WORKDIR /flan-api

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile /flan-api
COPY Gemfile.lock /flan-api
RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . /flan-api
# RUN bundle exec rake DATABASE_URL=postgresql:does_not_exist assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]