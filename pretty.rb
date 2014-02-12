#!/usr/bin/env ruby
require 'nokogiri'


doc = Nokogiri::HTML(ARGF.read)

core = Nokogiri::HTML(doc.css('#bodyContent').first.to_html)

core.css('#toc').first.remove

doc.css('style').each do |style|
  core.css('body').first << style
end

puts core.to_html
