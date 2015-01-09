# This code amounts to a framework built on top of Sinatra.  More precisely,
# it amounts to configuration, monkey patches, and content that has yet to
# be refactored into a proper framework.

require 'wunderbar/sinatra'
require 'wunderbar/script'
require 'nokogumbo'
require 'fileutils'
require 'github/markdown'

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
Dir[File.expand_path('../views/_*.rb', __FILE__)].each do |file|
  Wunderbar.templates[File.basename(file)[/_(\w+)/,1].gsub('_', '-')] =
    eval(File.read(file))
  require file
end

def capture(mtime, result)
  unless settings.test?
    path = "/var/www/blog#{env['PATH_INFO']}"
    target = File.expand_path(path, __FILE__)

    if not File.exist?(target) or File.read(target) != result
      FileUtils.mkdir_p File.dirname(target)
      File.open(target, 'w') {|file| file.write result}
    end

    if not File.mtime(target) == mtime
      File.utime Time.now, mtime, target
    end
  end

  result
end

set :views, File.expand_path('../views', __FILE__)

if settings.test?
  Post.load('test')
else
  Post.load('production')
end

# The following adds Sinatra Atom support.  This should be expanded to
# include CGI and Rails, and folded into Wunderbar itself.
module Wunderbar
  module SinatraHelpers
    def _atom(*args, &block)
      Wunderbar::Template.locals(self, args)

      if block
        Wunderbar::Template::Atom.evaluate('atom.rb', self) do
          _atom(*args) { instance_eval &block }
        end
      else
        Wunderbar::Template::Atom.evaluate('atom.rb', self, *args)
      end
    end
  end

  module Template
    class Atom < Base
      self.default_mime_type = 'application/atom+xml;charset=utf-8'

      def evaluate(scope, locals, &block)
        builder = AtomMarkup.new(scope)
        begin
          _evaluate_safely(builder, scope, locals, &block)
        rescue Exception => exception
          scope.response.status = 500
          builder.clear!
          builder.html do
            _h1 'Internal Server Error'
            _exception exception
          end
        end
        builder._.target!
      end
    end
  end

  class AtomMarkup < HtmlMarkup
    def _atom(*args, &block)
      # default namespace
      args << {} if args.empty?
      if Hash === args.first
        args.first[:xmlns] ||= 'http://www.w3.org/2005/Atom'
        @_x.width = args.first.delete(:_width).to_i if args.first[:_width]
      end

      tag!('atom', *args) do
        block.call if block
      end
    end

    def _content(*args, &block)
      if block
        tag! 'content', *args do
          _div xmlns: 'http://www.w3.org/1999/xhtml' do
            _ &block
          end
        end
      else
        _tag! 'content', *args
      end
    end

    def _summary(*args, &block)
      if block
        tag! 'summary', *args do
          _div xmlns: 'http://www.w3.org/1999/xhtml' do
            _ &block
          end
        end
      else
        _tag! 'summary', *args
      end
    end

    def _updated(*args, &block)
      args.unshift args.shift.iso8601 if Time === args.first
      tag! 'updated', *args, &block
    end
  end
end

Tilt.register 'atom.rb', Wunderbar::Template::Atom
