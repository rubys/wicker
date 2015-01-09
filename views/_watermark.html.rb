_svg_ viewBox: '0 0 100 100' do
  _defs_ xlink: 'http://www.w3.org/1999/xlink' do
    _radialGradient.i1! fx: '.4', fy: '.2', r: '.7' do
      _stop stop_color: '#FE8', offset: '0'
      _stop stop_color: '#D70', offset: '1'
    end
    _radialGradient.i2! fx: '.8', fy: '.5', 'xlink:href' => '#i1'
    _radialGradient.i3! fx: '.5', fy: '.9', 'xlink:href' => '#i1'
    _radialGradient.i4! fx: '.1', fy: '.5', 'xlink:href' => '#i1'
  end
  _g stroke: '#940' do
    _path d: 'M73,29c-37-40-62-24-52,4l6-7c-8-16,7-26,42,9z', fill: 'url(#i1)'
    _path d: 'M47,8c33-16,48,21,9,47l-6-5c38-27,20-44,5-37z', fill: 'url(#i2)'
    _path d: 'M77,32c22,30,10,57-39,51l-1-8c3,3,67,5,36-36z', fill: 'url(#i3)'
    _path d: 'M58,84c-4,20-38-4-8-24l-6-5c-36,43,15,56,23,27z', fill: 'url(#i4)'
    _path d: 'M40,14c-40,37-37,52-9,68l1-8c-16-13-29-21,16-56z', fill: 'url(#i1)'
    _path d: 'M31,33c19,23,20,7,35,41l-9,1.7c-4-19-8-14-31-37z', fill: 'url(#i2)'
  end
end
