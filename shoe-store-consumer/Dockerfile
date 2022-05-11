FROM ruby:3.1
RUN mkdir /app
ADD . /app
WORKDIR /app

RUN gem install bundler
RUN bundle install

CMD ["ruby consumer.rb"]