#!/usr/bin/ruby
require 'time'
require 'nokogumbo'
fileformat = 'http://www.fileformat.info/info/unicode/char'

posts = %w(one two three four five six seven eight nine ten eleven twelve)

posts.each_with_index do |name, number|
  codepoint = 0x2460 + number
  number += 1
  time = Time.parse("2014-#{number}-#{number} #{number}:#{number}:#{number}")
  page = Nokogiri::HTML5.get("#{fileformat}/#{codepoint.to_s(16)}/index.htm")
  url = URI.join(fileformat, page.search('li a')[2]['href'])
  svg = Nokogiri::HTML5.get(url).at('svg')
  svg.attributes.each do |name, value|
    svg.delete(name) unless %w(xmlns).include? name
  end
  svg['viewBox'] = '0 0 100 100'
  svg.at('g')['transform'] = 'scale(0.408) translate(-21,-175)'

  puts name
  post = File.expand_path("../../db/test/#{name}.txt", __FILE__)
  File.open(post, 'w') do |file|
    file.puts name.capitalize
    file.puts "<div class='excerpt'>#{([name]*[number,3].min).join(' ')}</div>"
    file.puts svg.to_s
    file.puts "<p>#{([name]*number).join(' ')}</p>"
  end
  File.utime(time, time, post)
end
