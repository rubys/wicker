require 'fileutils'

class Post
  attr_reader :filename, :mtime
  @@posts = {}

  def self.load(env)
    @@dir = File.expand_path("../../db/#{env}", __FILE__).untaint
    @@env = env

    Dir.chdir(@@dir) do
      Dir['*.txt'].each do |post|
        post.untaint
        time = File.mtime(post)
        @@posts[time] = Post.new(post, time)
      end
    end
  end

  def self.all
    @@posts
  end

  def self.find(link)
    @@posts.find {|mtime, post| post.link == link}
  end

  def initialize(filename, mtime)
    @filename = filename
    @mtime = mtime
  end

  def title
    read unless @title
    @title
  end

  def slug
    read unless @title
    name = filename.sub(/(\.txt|-\d+\.cmt)$/, '')
    if @title == '' or name =~ /\D/
      return name.gsub('_', '-')
    end
    title = @title.gsub("'", '').gsub(/\&#?\w+;/, '').gsub(/<.*?>/, '')
    title.gsub(/\W+/, '-')
  end

  def link
    @link ||= @mtime.strftime('%Y/%m/%d/') + slug
  end

  def excerpt
    read unless @excerpt
    return unless @excerpt

    if @excerpt.include? '<p>'
      @excerpt.sub!(/\A<div.*?>/, '')
      @excerpt.sub!(/<\/div>\Z/, '')
    else
      @excerpt.sub!(/\A<div.*?>/, '<p>')
      @excerpt.sub!(/<\/div>\Z/, '</p>')
    end

    @excerpt
  end

  def icon(scale=1)
    read unless @icon
    return unless @icon

    # determine the height and width
    decl = @icon[/<.*?>/m]
    decl.sub! /\s+style=(['"]).*?\1/, ''
    height = decl[/\sheight=["'](\d+)["']/, 1]
    width = decl[/\swidth=["'](\d+)["']/, 1]
    viewbox = decl[/\sviewBox=['"]([-\d\s\.]*?)["']/, 1]
    viewbox ||= "0 0 #{width} #{height}"

    # scale the height and width
    viewbox = viewbox.split(/\s+/).map {|n| n.to_f}
    decl[/()>/, 1] = " width='#{(viewbox[2]*scale).round}'" unless width
    decl[/()>/, 1] = " height='#{(viewbox[3]*scale).round}'" unless height

    # replace declaration; insert spaces in paths
    @icon.sub(/<.*?>/m, decl).gsub(/<path.*?>/) do |path|
      path.sub(/\s+d=['"].*?['"]/) do |d|
        d.gsub(/([a-yA-y]-?\d)/, ' \1').sub(/(d=['"]) /, '\1')
      end
    end
  end

  def body
    read unless @body

    if not @body.include? '<p>'
      "<p>#{@body}</p>"
    elsif @body.include? "\n\n"
      @body
    else
      (@body.gsub(/^<(\w+).*?<\/\1>/m) {|element| "\n#{element}"}).strip
    end
  end

  def read
    contents = File.read("#{@@dir}/#{@filename}")
    @title, contents = contents.split("\n", 2)
    @excerpt = contents[/\A<div class=['"]excerpt['"].*?<\/div>\n?/m]

    if @excerpt
      contents = contents[@excerpt.length..-1]
    end

    @icon = contents[/\A<svg.*?<\/svg>\n?/m]

    if @icon
      contents = contents[@icon.length..-1]
    end

    @body = contents
  end

  def comments
    return unless @filename =~ /\.txt$/
    @comments ||= Dir.chdir(@@dir) do
      Dir["#{@filename.sub(/\.txt$/, '')}-*.cmt"].map do |comment|
        Post.new(comment, File.mtime(comment.untaint))
      end
    end
  end

  def fragment
    name = @filename[/-(\d+)\.cmt$/, 1]
    name && "c#{name}"
  end

  def tag
    "tag:intertwingly.net,2004:#{filename.sub('.txt', '')}"
  end

  def self.render(params, mtime)
    content = GitHub::Markdown.render(params['comment'])
    name = CGI.escapeHTML(params['name'] || 'anonymous')
    content += "<p>Posted by #{name}</p>"
    [mtime.iso8601, content]
  end

  def comment(params)
    mtime = Time.now
    params[mtime] = mtime.to_f
    pending << Post.render(params, mtime)
    return if @@env == 'test'

    puts FileUtils.mkdir_p "#{@@dir}/#{link}"
    FileUtils.mkdir_p "#{@@dir}/#{link}"
    File.open("#{@@dir}/#{link}/#{mtime.to_f}.mod", 'w') do |file|
      file.write JSON.pretty_generate params
    end
    File.utime(mtime, mtime, "#{@@dir}/#{link}/#{mtime.to_f}.mod")
  end

  def pending
    @pending ||= Dir.chdir(@@dir) do
      Dir["#{link}/*.mod".untaint].map do |file|
        data = JSON.parse(File.read(file.untaint))
        Post.render(data, File.mtime(file.untaint))
      end
    end
  end
end
