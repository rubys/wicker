get '/' do
  @index = Post.all.sort.reverse[0..9]
  capture Time.now, _html(:index)
end

get '/index.html' do
  call env.merge("PATH_INFO" => '/')
end

get %r{/(\d\d\d\d/\d\d/\d\d)/(.*)} do |date, slug|
  link = "#{date}/#{slug}"
  @mtime, @post = Post.find(link)
  pass unless @post
  capture @post.mtime, _html(:entry)
end

get '/update' do
  _html :update
end

get '/dir' do
  _html :dir
end

get '/env' do
  env.inspect
end

get '/dump' do
  @mtime, @post = POSTS.sort.last
  _html :dump
end
