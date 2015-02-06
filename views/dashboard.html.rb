_html lang: 'en' do
  _title 'Intertwingly Dashboard'
  _link rel: 'stylesheet', href: '/blog/screen.css', type: 'text/css', 
    media: 'screen'
  _link rel: 'stylesheet', href: '/blog/print.css', type: 'text/css', 
    media: 'print'
  _link rel: 'shortcut icon', href: '/favicon.ico'

  _banner

  _article_ do
    _header_! { _h3 {_a 'Actions'} }
      
    _select name: 'pages' do
      _option 'index.html'
      Post.all.sort.each do |mtime, post|
        _option post.link
      end
    end

    _button 'Update'

    _form_ method: 'post' do
      _p
      Dir['bin/*'].each do |script|
        next if script =~ /\.rb$/
        _button File.basename(script), name: 'script', value: script
      end
      _p
    end
  end

  if @script and Dir['bin/*'].include? @script
    _article_ do
      _header_! { _h3 {_a "#@script results"} }
      _pre `#{File.expand_path(@script).untaint}`
    end
  end

  _aside do
    _sidebar
  end

  _footer_ do
    _menu
    _watermark
  end

  _script do
    def fetch(url)
      xhr = XMLHttpRequest.new()
      def xhr.onreadystatechange()
        self._then(self) if xhr.readyState == 4
      end

      def xhr.then(f)
        @then = f
      end

      def xhr.json()
        return JSON.parse(xhr.responseText)
      end

      xhr.open 'GET', url
      xhr.send nil

      return xhr
    end

    options = document.querySelectorAll('option')
    button = document.querySelector('button')

    def update(options, i)
      fetch(options[i].value).then do
        options[i].selected = true
        if i < options.length-1
          update(options, i+1) 
        else
          button.disabled = false
        end
      end
    end

    def button.onclick()
      button.disabled = true
      update(options, 0) if options.length
    end
  end
end

