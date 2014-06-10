require 'rubygems'
require 'aws-sdk'
require 'securerandom'
require 'open-uri'
require 'base64'

require './config.rb'

print "ACCESS_KEY:"
ACCESS_KEY = gets.chomp
  
print "SECRET_KEY:"
SECRET_KEY = gets.chomp

puts "REGION: Select your region number ->"
REGION_LIST.sort.each { |reg|
  puts "  " + reg[0].to_s + " = " + reg[1].to_s
}
print "REGION:"
REGION = gets.to_i

print "VPC_ID:"
VPC_ID = gets.chomp

puts "INSTANCE_TYPE: Select your instance type number ->"
INSTANCE_LIST.sort.each { |type|
  puts "  " + type[0].to_s + " = " + type[1].to_s
}
print "INSTANCE_TYPE:"
INSTANCE_TYPE = gets.to_i
 
print "KEY_NAME:"
KEY_NAME = gets.chomp

print "ACCESS_FROM_IP_ADDRESS:"
ACCESS_FROM_IP_ADDRESS = gets.chomp

print "USERDATA(file path):"
USERDATA = gets.chomp

print "Number of Instances:"
NUM = gets.chomp

security_group_name = "CoreSerers_" + SecureRandom.hex(12)

f = open(USERDATA)
userdata = Base64.encode64(f.read)
f.close

ami = Hash.new
amilist = String.new
url = "http://storage.core-os.net/coreos/amd64-usr/alpha/coreos_production_ami_all.txt"
open(url){|cnt| amilist = cnt.read.chomp }
amilist.split("|").each {|pair|
  reg, ami_id = pair.split("=")
  ami.store(reg,ami_id)
}

ec2 = AWS::EC2.new(
  :access_key_id => ACCESS_KEY,
  :secret_access_key => SECRET_KEY,
  :region => REGION_LIST[REGION]
).client

create_security_group_res = ec2.create_security_group(
  :group_name => security_group_name, 
  :description => "CoreServers",
  :vpc_id => VPC_ID
)
security_group_id = create_security_group_res[:group_id]
 
ec2.authorize_security_group_ingress(
  :group_name => security_group_name,
  :ip_permissions => [
    {
      :ip_protocol => 'tcp', 
      :from_port => 22, 
      :to_port => 22, 
      :ip_ranges => [:cidr_ip => ACCESS_FROM_IP_ADDRESS]
    },
    {
      :ip_protocol => 'tcp', 
      :from_port => 4001, 
      :to_port => 4001, 
      :user_id_group_pairs => [:group_name => security_group_name]
    },
    {
      :ip_protocol => 'tcp', 
      :from_port => 7001, 
      :to_port => 7001, 
      :user_id_group_pairs => [:group_name => security_group_name]
    }
  ]
)

NUM.to_i.times {
  ec2.run_instances(
    :image_id => ami[REGION_LIST[REGION]],
    :min_count => 1,
    :max_count => 1,
    :key_name => KEY_NAME,
    :instance_type => INSTANCE_LIST[INSTANCE_TYPE],
    :user_data => userdata,
    :network_interfaces => [
      :device_index => 0,
      :groups => [security_group_id],
      :associate_public_ip_address => true
    ]
  )
} 
