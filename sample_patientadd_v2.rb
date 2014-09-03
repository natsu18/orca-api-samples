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


req = Net::HTTP::Post.new("/orca12/patientmodv2?class=01")
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
                <Patient_ID type="string">*</Patient_ID>
                <WholeName type="string">#{name}</WholeName>
                <WholeName_inKana type="string">#{kana_name}</WholeName_inKana>
                <BirthDate type="string">#{birth_date}</BirthDate>
                <Sex type="string">#{rand(2)+1}</Sex>
                <HouseHolder_WholeName type="string">#{name}</HouseHolder_WholeName>
                <Relationship type="string">本人</Relationship>
                <Occupation type="string">会社員</Occupation>
                <CellularNumber type="string">09011112222</CellularNumber>
                <FaxNumber type="string">03-0011-2233</FaxNumber>
                <EmailAddress type="string">test@tt.dot.jp</EmailAddress>
                <Home_Address_Information type="record">
                        <Address_ZipCode type="string">1130021</Address_ZipCode>
                        <WholeAddress1 type="string">東京都文京区本駒込</WholeAddress1>
                        <WholeAddress2 type="string">６−１６−３</WholeAddress2>
                        <PhoneNumber1 type="string">03-3333-2222</PhoneNumber1>
                        <PhoneNumber2 type="string">03-3333-1133</PhoneNumber2>
                </Home_Address_Information>
                <!--
                <WorkPlace_Information type="record">
                        <WholeName type="string">てすと　株式会社</WholeName>
                        <Address_ZipCode type="string">1130022</Address_ZipCode>
                        <WholeAddress1 type="string">東京都文京区本駒込</WholeAddress1>
                        <WholeAddress2 type="string">５−１２−１１</WholeAddress2>
                        <PhoneNumber type="string">03-3333-2211</PhoneNumber>
                </WorkPlace_Information>
                <Contraindication1 type="string">状態</Contraindication1>
                <Allergy1 type="string">アレルギ</Allergy1>
                <Infection1 type="string">感染症</Infection1>
                <Comment1 type="string">コメント</Comment1>
                <HealthInsurance_Information type="record">
                        <InsuranceProvider_Class type="string">060</InsuranceProvider_Class>
                        <InsuranceProvider_Number type="string">138057</InsuranceProvider_Number>
                        <InsuranceProvider_WholeName type="string">国保</InsuranceProvider_WholeName>
                        <HealthInsuredPerson_Symbol type="string">０１</HealthInsuredPerson_Symbol>
                        <HealthInsuredPerson_Number type="string">１２３４５６７</HealthInsuredPerson_Number>
                        <RelationToInsuredPerson type="string">1</RelationToInsuredPerson>
                        <Certificate_StartDate type="string">2010-05-01</Certificate_StartDate>
                        <PublicInsurance_Information type="array">
                                <PublicInsurance_Information_child type="record">
                                        <PublicInsurance_Class type="string">010</PublicInsurance_Class>
                                        <PublicInsurance_Name type="string">感３７の２</PublicInsurance_Name>
                                        <PublicInsurer_Number type="string">10131142</PublicInsurer_Number>
                                        <PublicInsuredPerson_Number type="string">1234566</PublicInsuredPerson_Number>
                                        <Certificate_IssuedDate type="string">2010-05-01</Certificate_IssuedDate>
                                </PublicInsurance_Information_child>
                        </PublicInsurance_Information>
                </HealthInsurance_Information>
                -->
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

