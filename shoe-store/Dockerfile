FROM ruby:3.1
RUN mkdir /app
ADD . /app
WORKDIR /app
EXPOSE 8080
RUN ls
CMD ["./bin/websocketd --port=8080 ruby inventory.rb"]
