#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

def post_to_elasticsearch(es_host, index, type ,json)
  # ex: http://localhost:9200/soramame/kyushu
  uri  = "#{es_host}" + "/" + "#{index}" + "/" + "#{type}"
  uri  = URI.parse(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  req  = Net::HTTP::Post.new(uri.request_uri)

  req["Content-Type"] = "application/json"
  req.body = json
  res = http.request(req)

  puts "code -> #{res.code}"
  puts "msg  -> #{res.message}"
  puts "body -> #{res.body}"
end
