_form_.comment_form! method: 'post', accept_charset: 'utf-8' do
  _p_ do
    _label 'Name:', for: 'name'
    _input.name! maxlength: '50', name: 'name', size: '75', 
      type: 'text', value: ''
  end

  _p_ do
    _label 'E-mail:', for: 'email'
    _input.email! maxlength: '75', name: 'email', size: '75',
      type: 'email', value: ''
  end

  _p_ do
    _label 'URL:', for: 'url'
    _input.url! maxlength: '100', name: 'url', size: '75', type: 'url',
      value: ''
  end

  _p_ do
    _label 'Comment:', for: 'comment'
    _textarea.comment! @comment, cols: '59', name: 'comment', rows: '12',
      readonly: (@preview != nil)
  end

  if @preview
    _input name: 'edit', type: 'submit', value: 'Edit'
    _input name: 'submit', type: 'submit', value: 'Submit'
  else
    _input name: 'preview', type: 'submit', value: 'Preview'
  end

  _span.storage_options do
    _input.clear_info! type: 'button', value: 'Clear Info'
    _input.remember_me! type: 'checkbox', name: 'rememberMe'
    _label 'Remember info?', for: 'rememberMe'
  end
end
