#!/usr/bin/ruby

require 'uri'
require 'net/http'

require 'pp'
require 'crack'
require 'crack/xml'

Net::HTTP.version_1_2

HOST = "192.168.4.123"
PORT = "8000"
USER = "ormaster"
PASSWD = "ormaster123"
CONTENT_TYPE = "application/xml"

req = Net::HTTP::Post.new("/api01rv2/patientlst3v2?class=01")

puts ""
  wholename=ARGV[0]
  puts "氏名検索:#{wholename}"
puts ""
puts "------------------------------"
puts ""

BODY = <<EOF
<data>
        <patientlst3req type="record">
                <WholeName type="string">#{wholename}</WholeName>
                <Birth_StartDate type="string"></Birth_StartDate>
                <Birth_EndDate type="string"></Birth_EndDate>
                <Sex type="string"></Sex>
                <InOut type="string"></InOut>
        </patientlst3req>
</data>
EOF

def list_patient_xml(body)
  root=Crack::XML.parse(body)
  result=root["xmlio2"]["patientlst2res"]["Api_Result"]
  unless result=="00"
    puts "error:#{result}"
    exit 1
  end

  pinfo=root["xmlio2"]["patientlst2res"]["Patient_Information"]
  pinfo.each do |patient|
    puts "患者番号:#{patient["Patient_ID"]}"
    puts "名前:#{patient["WholeName"]}"
    puts "フリガナ:#{patient["WholeName_inKana"]}"
    puts "生年月日:#{patient["BirthDate"]}"
    if patient["Sex"]=="1"
      puts "性別:男"
    else
      puts "性別:女"
    end
  puts ""
  puts "******************************"
  puts ""

  end
end

req.content_length = BODY.size
req.content_type = CONTENT_TYPE
req.body = BODY
req.basic_auth(USER, PASSWD)

Net::HTTP.start(HOST, PORT) {|http|
  res = http.request(req)
  #puts res.code
  list_patient_xml(res.body)
}

