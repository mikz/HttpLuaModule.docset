#!/usr/bin/env ruby

require 'nokogiri'
require 'pathname'


file = Pathname.new(ARGV.first).basename


html = Nokogiri::HTML(ARGF.read)

content = html.css('#mw-content-text')
headings = content.css('h1,h2')


category = nil

headings.each do |heading|
  headline = heading.at_css('.mw-headline')
  id = headline['id']
  text = headline.text.strip
  
  case heading.name
  when 'h1'
    category = heading  
    puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{text}', 'Category', '#{file}##{id}');"
  when 'h2'
    puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{text}', 'Function', '#{file}##{id}');"
  else
    puts "UNKNOWN ELEMENT: #{heading.to_html}"
  end
end  
  