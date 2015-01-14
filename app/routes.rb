get '/' do
  call env.merge('PATH_INFO' => '/index.html')
end

get '/index.html' do
  @index = Post.all.sort.reverse[0..9]
  capture Time.now, _html(:index)
end

get '/index.atom' do
  @index = Post.all.sort.reverse[0..9]
  @updated = @index.first.first
  capture Time.now, _atom(:index)
end

get %r{/(\d\d\d\d/\d\d/\d\d)/(.*?)/pending.json} do |date, slug|
  link = "#{date}/#{slug}"
  mtime, post = Post.find(link)
  pass unless post
  _json do
    _! post.pending
  end
end

get %r{/(\d\d\d\d/\d\d/\d\d)/(.*)} do |date, slug|
  link = "#{date}/#{slug}"
  @mtime, @post = Post.find(link)
  pass unless @post
  capture @post.mtime, _html(:entry)
end

post %r{/(\d\d\d\d/\d\d/\d\d)/(.*)} do |date, slug|
  link = "#{date}/#{slug}"
  mtime, @post = Post.find(link)
  pass unless @post

  if params[:submit]
    @post.comment(params.merge(env))
    call env.merge('REQUEST_METHOD' => 'GET')
  else
    @mtime = Time.now
    @comment = params[:comment]
    _html :preview
  end
end

get %r{/archives/(\d\d\d\d)/(\d\d)} do |year, month|
  month, year = month.to_i, year.to_i

  @dates = (1..31).select {|day| Date.valid_date?(year, month, day)}.
    map {|day| Date.new(year, month, day)}
  @weeks = @dates.group_by {|date| date.strftime('%U')}

  @posts = Hash[@dates.map {|date| [date.day, []]}]
  Post.all.each do |mtime, post|
    @posts[mtime.day] << post if mtime.year == year and mtime.month == month
  end

  _html :archives
end

get '/update' do
  _html :update
end
