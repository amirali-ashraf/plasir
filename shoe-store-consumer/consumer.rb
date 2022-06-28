require 'faye/websocket'
require 'eventmachine'
require 'json'
require "uri"
require "net/http"



p 'Hi'
EM.run {
  ws = Faye::WebSocket::Client.new('ws://plasir_producer_1:8080/')

  ws.on :message do |event|
    data = JSON.parse(event.data)

    url = URI("http://plasir:3000/api/v1/feeds")

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = event.data

    response = http.request(request)
    p response.read_body
  end
}
