#!/usr/bin/env ruby

require './lib/dynamodb'

# 
begin
  resp = create_table('soramame')
rescue
  print "Error: #$!\n"
else
  puts "Table " + resp.table_description.table_name + " created."
end
