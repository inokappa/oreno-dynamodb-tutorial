#!/usr/bin/env ruby

require './lib/dynamodb'

# 
begin 
  resp = delete_table('soramame')
rescue
  print "Error: #$!\n"
else
  puts "Table " + resp.table_description.table_name + " deleted."
end
