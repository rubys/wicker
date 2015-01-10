_html lang: 'en', _width: '99' do
  _title "Sam Ruby: #{@post.title}"
  _link rel: 'stylesheet', href: '/css/blogy.css', type: 'text/css', 
    media: 'screen'
  _link rel: 'stylesheet', href: '/css/print.css', type: 'text/css', 
    media: 'print'
  _link rel: 'shortcut icon', href: '/favicon.ico'
  _script :defer, src: '/js/localize_dates.js'
  _script :defer, src: '/js/comment_form.js'

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
