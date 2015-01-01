#!/usr/bin/ruby
require 'time'
require 'nokogumbo'
require 'fileutils'
fileformat = 'http://www.fileformat.info/info/unicode/char'

dest = File.expand_path("../../db/test", __FILE__)
FileUtils.mkdir_p dest

posts = %w(one two three four five six seven eight nine ten eleven twelve)

posts.each_with_index do |name, number|
  post = "#{dest}/#{name}.txt"
  next if File.exist? post

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
  File.open(post, 'w') do |file|
    file.puts name.capitalize
    file.puts "<div class='excerpt'>#{([name]*[number,3].min).join(' ')}</div>"
    file.puts svg.to_s
    file.puts "<p>#{([name]*number).join(' ')}</p>"
  end
  File.utime(time, time, post)
end

time = Time.parse('2014-12-12 12:12:12').utc
posts.each_with_index do |name, number|
  time += 60*60
  comment = "#{dest}/twelve-#{time.to_i}.cmt"
  next if File.exist? comment
  File.open(comment, 'w') do |file|
    file.puts 'Twelve'
    file.puts name
  end
  File.utime(time, time, comment)
end

time = Time.parse('2014-05-05 05:05:05').utc + 60*60
comment = "#{dest}/five-#{time.to_i}.cmt"
unless File.exist? comment
  File.open(comment, 'w') do |file|
    file.puts 'Five'
    file.puts 'comment'
  end
  File.utime(time, time, comment)
end
