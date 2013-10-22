#!/usr/bin/env ruby
require 'nokogiri'


doc = Nokogiri::HTML(ARGF.read)

doc.css('span.editsection').each do |editsection|
  editsection.remove
end

puts doc.to_html
  