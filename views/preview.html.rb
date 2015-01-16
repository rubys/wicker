_html lang: 'en' do
  _title "Sam Ruby: #{@post.title}"
  _link rel: 'stylesheet', href: '/blog/screen.css', type: 'text/css', 
    media: 'screen'
  _link rel: 'stylesheet', href: '/blog/print.css', type: 'text/css', 
    media: 'print'
  _link rel: 'shortcut icon', href: '/favicon.ico'
  _script :defer, src: '/blog/localize_dates.js'
  _script :defer, src: '/blog/comment_form.js'

  _banner

  _article_ do
    _header_ do
      _h3! { _a @post.title, href: '' }
      _time @mtime.utc.httpdate, title: 'GMT', datetime: @mtime.utc.iso8601
    end

    _ {GitHub::Markdown.render @comment}

    _footer_
  end

  _section do
    _header do
      if @edit
        _h2 'Edit your comment'
      else
        _h2 'Preview your comment'
      end
    end

    _article do
      _comment_form
    end
  end

  _sidebar

  _footer_ do
    _menu
    _watermark
  end
end
