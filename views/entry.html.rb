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

    __{@post.icon.untaint} if @post.icon

    _{@post.body.untaint}

    _footer_
  end

  _a_.comments!

  sections = @post.comments.group_by {|comment| comment.mtime.utc.to_date}
  sections.sort.each do |date, comments|
    _section_ do
      _header_ do
        _h2! {_time date.to_s, datetime: date.to_s}
      end

      comments.sort_by {|comment| comment.mtime}.each_with_index do |comment, i|
        _hr if i != 0

        _article_ id: comment.fragment do
          _{comment.body.untaint}
          _ 'at'
          _a href: "##{comment.fragment}" do
            _time comment.mtime.utc.strftime('%H:%M:%S'), title: 'GMT',
              datetime: comment.mtime.utc.iso8601
          end
        end
      end
    end
  end

  _section do
    _header_ do
      _h2 'Add your comment'
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
