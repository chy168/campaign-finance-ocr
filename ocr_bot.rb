require 'tesseract'
require "net/http"
require "uri"
require "json"
require "httparty"

e = Tesseract::Engine.new {|e|
    e.language  = :eng
      e.blacklist = '|'
}

# http://campaign-finance-pic.ronny.tw/{page}/{row}-{column}.png
# n-1 transaction date (y=2)
# n-4 social ID
# n-5 income $$
# n-6 spend $$

# Mapping urls: /3026/1-1.png => /getcellvalue/3026/2/2

# http://campaign-finance.g0v.ronny.tw/api/getcellimage/2769/5/7.png
# 第 2769 頁 (5, 7 )
# POST Request URL:http://campaign-finance.g0v.ctiml.tw/api/fillcell/2769/5/7
#
# Get fewer count
# http://campaign-finance.g0v.ctiml.tw/api/getrandoms
#

sleep(2)

uri = URI.parse("http://campaign-finance.g0v.ctiml.tw/api/getrandoms")

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)
body = JSON.parse(response.body)

rr = body.first
puts "(#{rr['x']}, #{rr['y']}) => img: #{rr['img_url']} -> http://campaign-finance-pic.ronny.tw/#{rr['page']}/#{rr['x']-1}-#{rr['y']-1}.png"

File.open("/tmp/gg/#{rr['page']}_#{rr['x']-1}-#{rr['y']-1}.png", "wb") do |f|
  f.write HTTParty.get("http://campaign-finance-pic.ronny.tw/#{rr['page']}/#{rr['x']-1}-#{rr['y']-1}.png").parsed_response
end



body.each do |r|
  # puts "(#{r['x']}, #{r['y']}) => img: #{r['img_url']} -> http://campaign-finance-pic.ronny.tw/#{r['page']}/#{r['x']-1}-#{r['y']-1}.png"  if [2,5].include?(r['y'])
end



# puts e.text_for('~/Desktop/3-1.png').strip

