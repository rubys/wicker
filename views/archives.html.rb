_html lang: 'en' do
  _title "Sam Ruby: #{@dates.first.strftime('%B %Y')}"
  _link rel: 'stylesheet', href: '/blog/screen.css', type: 'text/css'

  _banner

  _table_.calendar do
    _caption do
      _a @dates.first.strftime('%B %Y')
    end

    headings = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

    _thead_ do
      _tr do
        headings.each {|day| _th day}
      end
    end

    _tbody do
      @weeks.each do |week, dates|
        dates = Hash[dates.map {|date| [date.strftime('%A'), date.day]}]
        _tr_ do
          headings.each do |day|
            if not dates[day]
              _td
            elsif @posts[dates[day]].empty?
              _td! { _div.day dates[day] }
            else
              _td do
                _div.day dates[day]
                _ul do
                  @posts[dates[day]].each do |post|
                    _li do 
                      _a href: "../../#{post.link}" do
                        _ post.title
                      _{post.icon(0.4).untaint}
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  _div!.leftbar do
    prev_month = @dates.first - 1
    _h2 do
      _a prev_month.strftime('%B %Y'), href: prev_month.strftime('../%Y/%m')
    end
  end
  _div!.rightbar do
    next_month = @dates.last + 1
    _h2 do
      _a next_month.strftime('%B %Y'), href: next_month.strftime('../%Y/%m')
    end
  end

  _footer_ do
    _menu
    _watermark
  end
end
