_html do
  _select name: 'pages' do
    _option 'index.html'
    Post.all.sort.each do |mtime, post|
      _option post.link
    end
  end

  _button 'Update'

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

