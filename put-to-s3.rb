#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'date'
require 'json'

d = Time.now.strftime("%Y%m%d")
h = (Time.now - 2 * 60 * 60).strftime("%H")
check_time = (Time.now - 2 * 60 * 60).strftime("%Y-%m-%d %H:00:00")
url = 'http://soramame.taiki.go.jp/Gazou/Hyou/AllMst/' + d + '/hb' + d + h + '08.html'
charset = nil

html = open(url) do |f|
  charset = f.charset
  f.read
end

header = ['CHECK_TIME','mon_st_code','town_name', 'mon_st_name', 'SO2','NO','NO2','NOX','CO','OX','NMHC','CH4','THC','SPM','PM2.5','SP','WD','WS','TEMP','HUM','mon_st_kind']

doc = Nokogiri::HTML.parse(html, nil, charset)
doc.xpath('//tr[td]').each do |tr|
  row = tr.xpath('td').map { |td| td.content.gsub(/[\u00A0\n]|\-\-\-/,'NA') }
  row.unshift(check_time)
  ary = [header,row].transpose
  h = Hash[*ary.flatten]
  p h
end
