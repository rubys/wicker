_atom do
  _title 'Sam Ruby'
  _subtitle 'It’s just data'
  __
  _link href: '/blog/'
  _link rel: 'self', href: 'http://intertwingly.net/blog/index.atom'
  _id 'http://intertwingly.net/blog/index.atom'
  _icon '../favicon.ico'
  _updated @updated

  _author_ do
    _name 'Sam Ruby'
    _email 'rubys@intertwingly.net'
    _uri '/blog/'
  end

  @index.each do |mtime, entry|
    _entry_ do
      _id entry.tag
      _link href: entry.link
      _title entry.title.untaint
      _summary_ {entry.excerpt.untaint} if entry.excerpt

      if entry.icon
        icon = entry.icon.sub('<svg ', '<svg style="float:right" ')
        _content_ {icon.untaint + "\n" + entry.body.untaint}
      else
        _content_ {entry.body.untaint}
      end

      _updated mtime
    end
  end
end
