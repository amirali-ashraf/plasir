# syntax=docker/dockerfile:1
FROM ruby:3.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client curl
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY . /app
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

HEALTHCHECK --interval=12s --timeout=12s --start-period=30s \  
    CMD curl -fs http://localhost:3000/health_check || exit 1

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
