require 'wunderbar/sinatra'
require 'nokogumbo'
require 'fileutils'

require_relative 'app/routes'
require_relative 'models/post'

Wunderbar::Template::PASSABLE.push Post, Time, Date
Wunderbar::CALLERS_TO_IGNORE.clear

# Monkeypatch to address https://github.com/sinatra/sinatra/pull/907
module Rack
  class ShowExceptions
    alias_method :old_pretty, :pretty
    def pretty(*args)
      result = old_pretty(*args)
      def result.join; self; end
      def result.each(&block); block.call(self); end
      result
    end
  end
end

require 'ostruct'
Snippets = OpenStruct.new
Dir[File.expand_path('../views/_*.rb', __FILE__)].each {|file| require file}

def capture(mtime, result)
  path = "/var/www/blog#{env['PATH_INFO']}"
  path += 'index.html' if path.end_with? '/'
  target = File.expand_path(path, __FILE__)

  if not File.exist?(target) or File.read(target) != result
    FileUtils.mkdir_p File.dirname(target)
    File.open(target, 'w') {|file| file.write result}
  end

  if not File.mtime(target) == mtime
    File.utime Time.now, mtime, target
  end

  result
end

set :views, File.expand_path('../views', __FILE__)

if settings.test?
  Post.load('test')
else
  Post.load('production')
end
