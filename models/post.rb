class Post
  attr_reader :filename, :mtime
  @@posts = {}

  def self.load(env)
    @@dir = File.expand_path("../../db/#{env}", __FILE__).untaint

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

    decl = @icon[/<.*?>/m]
    decl.sub! /\s+style=(['"]).*?\1/, ''
    height = decl[/\sheight=["'](\d+)["']/, 1]
    width = decl[/\swidth=["'](\d+)["']/, 1]
    viewbox = decl[/\sviewBox=['"]([-\d\s\.]*?)["']/, 1]
    viewbox ||= "0 0 #{width} #{height}"

    viewbox = viewbox.split(/\s+/).map {|n| n.to_f}
    decl[/()>/, 1] = " width='#{(viewbox[2]*scale).round}'" unless width
    decl[/()>/, 1] = " height='#{(viewbox[3]*scale).round}'" unless height

    @icon.sub(/<.*?>/m, decl)
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
end
