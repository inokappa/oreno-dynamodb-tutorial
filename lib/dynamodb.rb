#!/usr/bin/env ruby

require 'aws-sdk-core'

$client = Aws::DynamoDB::Client.new(
  endpoint: ENV['DYNAMODB_ENDPOINT'], 
  # access_key_id: ENV['AWS_ACCESS_KEY'],
  # secret_access_key: ENV['AWS_SECRET_KEY'], 
  region: 'ap-northeast-1'
)

def post_to_dynamodb(table, data)
  result = $client.put_item(
    table_name: table,
    item: data
  )
  puts result
end

def list_tables
  result = $client.list_tables
  result.table_names.each do |table|
    puts table
  end
end

def create_table(table_name)
  table = $client.create_table({
    table_name: table_name ,
    key_schema:[
      {
        attribute_name: "mon_st_code",
        key_type: "HASH"
      },
      {
        attribute_name: "CHECK_TIME",
        key_type: "RANGE"
      },
    ],
    attribute_definitions: [
      {
        attribute_name: "CHECK_TIME",
        attribute_type: "S",
      },
      {
        attribute_name: "mon_st_code",
        attribute_type: "S",
      },
    ],
    provisioned_throughput: {
      read_capacity_units: 1,
      write_capacity_units: 1,
    },
  })
end

def delete_table(table_name)
  resp = $client.delete_table({
    table_name: table_name
  })
end

def get_item(table_name)
  #result = $client.get_item({
  #  table_name: table_name,
  #  key: {
  #    "mon_st_code" => "40137010", 
  #  },
  #})
  puts result
end

def query_item(table_name, filter_attribute, attribute_value, limit_num=1)
  result = $client.query({
    table_name: table_name,
    select: "ALL_ATTRIBUTES", 
    key_condition_expression: "mon_st_code = :v_mon_st_code and CHECK_TIME >= :v_check_time",
    expression_attribute_values: {
      ":v_mon_st_code" => "40137010",
      ":v_check_time" => "2015-08-12",
    },
  })
  
  result.items.each do |item|
    puts "-------------"
    item.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
end

def scan_item(table_name, filter_attribute, attribute_value, limit_num=1)
  result = $client.scan(
    table_name: table_name,
    select: "ALL_ATTRIBUTES", 
    # limit: 1,
    scan_filter: {
      "#{filter_attribute}" => {
        attribute_value_list: ["#{attribute_value}"], 
        comparison_operator: "CONTAINS",
      },
    },
  )
  
  result.items.each do |item|
    puts "-------------"
    puts item
    item.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
end
