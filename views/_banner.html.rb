_header_ do
  _h1 do
    _a.banner_anchor 'intertwingly', href: '/blog/'
  end

  _form method: 'get', action: '/blog/' do
    _label 'Search', for: 'q'
    _input.q! type: 'search', name: 'q', placeholder: 'Search', value: ''
  end
  _p "It’s just data"
end
