_html lang: 'en' do
  _title 'Sam Ruby'
  _link rel: 'alternate', type: 'application/atom+xml', 
    title: 'Sam Ruby', href: '/blog/index.atom'
  _link rel: 'stylesheet', href: '/blog/screen.css', type: 'text/css', 
    media: 'screen'
  _link rel: 'stylesheet', href: '/blog/print.css', type: 'text/css', 
    media: 'print'
  _link rel: 'shortcut icon', href: '/favicon.ico'
  _script :defer, src: '/blog/localize_dates.js'

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
    _sidebar
  end

  _footer_ do
    _menu
    _watermark
  end
end
