_html lang: 'en', _width: '99' do
  _title 'Sam Ruby'
  _link rel: 'alternate', type: 'application/atom+xml', 
    title: 'Sam Ruby', href: '/blog/index.atom'
  _link rel: 'stylesheet', href: '/css/blogy.css', type: 'text/css', 
    media: 'screen'
  _link rel: 'stylesheet', href: '/css/print.css', type: 'text/css', 
    media: 'print'
  _link rel: 'shortcut icon', href: '/favicon.ico'
  _script :defer, src: '/js/localize_dates.js'

  _header do
    _h1 do
      _a.banner_anchor 'intertwingly', href: 'http://intertwingly.net/blog/'
    end

    _form method: 'get', action: 'http://intertwingly.net/blog/' do
      _label 'Search', for: 'q'
      _input.q! type: 'search', name: 'q', placeholder: 'Search', value: ''
    end
    _p "It’s just data"
  end

  @index.each_with_index do |(mtime, post), index|
    _article_ do
      _header_ do
        _h3! do
          _a post.title, href: post.link
        end

        _time mtime.utc.httpdate, title: 'GMT', datetime: mtime.utc.iso8601
      end

      __{post.icon.untaint} if post.icon

      if index != 0 and post.excerpt
        _{post.excerpt.untaint}
        _p_! {_a '...', href: post.link}
      else
        _{post.body.untaint}
      end

      _footer_ do
        args = {title: post.title, href: "#{post.link}#comments"}
        if post.comments.empty?
          _a "Add comment", args
        elsif post.comments.length == 1
          _a "1 comment", args
        else
          _a "#{post.comments.length} comments", args
        end
      end
    end

    _hr_
  end

  _aside do
    _h2 'mingle'
    _nav do
      _ul do
        _li { _a 'About', href: 'http://en.wikipedia.org/wiki/Sam_Ruby' }
        _li { _a 'Twitter', href: 'http://twitter.com/samruby' }
        _li { _a 'Comments', href: 'http://intertwingly.net/blog/comments.html' }
        _li { _a.navbar_register! 'Register', href: 'http://intertwingly.net/blog/registry/' }
        _li { _a 'Statistics', href: 'http://intertwingly.net/stats/' }
        _li { _a 'Archives', href: 'http://intertwingly.net/blog/archives/' }
        _li { _a 'Planet', href: 'http://planet.intertwingly.net/' }
        _li { _a 'Code', href: 'http://code.intertwingly.net/public/' }
        _li { _a 'Rails', href: 'http://www.pragprog.com/titles/rails4/agile-web-development-with-rails-4th-edition' }
        _li { _a 'RESTful', href: 'http://www.oreilly.com/catalog/9780596529260/' }
        _li { _a 'Disclaimer', href: 'http://intertwingly.net/blog/2005/05/16/Disclaim-This' }
      end
    end
  end

  _footer_ do
    _ &Snippets.menu
    _ &Snippets.watermark
  end
end
