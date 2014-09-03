#!/usr/bin/ruby

$:.unshift File.dirname(__FILE__)

require 'uri'
require 'net/http'
require 'random_name'

def get_random_birth_date
  y=1900+rand(100)
  m=1+rand(12)
  d=1+rand(31)

  y=2013 if y>2013
  case m
  when 2
    d=28 if d>28
  when 4,6,9,11
   d=20 if d>30
  end
 sprintf("%04d-%02d-%02d",y,m,d)
end

Net::HTTP.version_1_2

HOST   = "localhost"
PORT   = "8000"
USER   = "ormaster"
PASSWD = "ormaster123"
CONTENT_TYPE = "application/xml"


req = Net::HTTP::Post.new("/orca12/patientmodv2?class=02")
# class  :01  登録
# class  :02  更新
# class  :03  削除
# class  :04  保険追加
#
#

name, kana_name=get_random_name
birth_date=get_random_birth_date

BODY = <<EOF
<data>
        <patientmodreq type="record">
                <Patient_ID type="string">#{ARGV[0]}</Patient_ID>
                <WholeName type="string">#{ARGV[1]}</WholeName>
                <WholeName_inKana type="string">#{ARGV[2]}</WholeName_inKana>
                <BirthDate type="string">#{ARGV[3]}</BirthDate>
                <Sex type="string">#{ARGV[4]}</Sex>
        </patientmodreq>
</data>
EOF

req.content_length = BODY.size
req.content_type = CONTENT_TYPE
req.body = BODY
req.basic_auth(USER, PASSWD)
puts req.body

Net::HTTP.start(HOST, PORT) {|http|
  res = http.request(req)
  puts res.body
}

