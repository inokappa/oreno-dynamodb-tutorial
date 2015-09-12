#!/usr/bin/env ruby

require 'aws-sdk-core'

$client = Aws::DynamoDB::Client.new(
  endpoint: ENV['DYNAMODB_ENDPOINT'], 
  region: 'ap-northeast-1'
)

def post_to_dynamodb(table, data)
  $client.put_item(
    table_name: table,
    item: data
  )
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
        attribute_name: "CHECK_TIME",
        key_type: "HASH"
      },
      {
        attribute_name: "mon_st_code",
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

def scan_item(table_name, filter_attribute, value)
  result = $client.scan(
    table_name: table_name,
    select: "ALL_ATTRIBUTES", 
    scan_filter: {
      "#{filter_attribute}" => {
        attribute_value_list: ["#{value}"], 
        comparison_operator: "CONTAINS",
      },
    },
  )
  
  result.items.each do |item|
    puts "-------------"
    item.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
end
