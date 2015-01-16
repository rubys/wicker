document.addEventListener("DOMContentLoaded", function(event) {
  var name = document.getElementById('name');
  var email = document.getElementById('email');
  var url = document.getElementById('url');
  var rememberMe = document.getElementById('remember-me');
  var preview = document.querySelector('input[value=Preview]');
  var submit = document.querySelector('input[value=Submit]');
  var edit = document.querySelector('input[value=Edit]');
  var comment = document.getElementById('comment');
  var baseline = comment.value;

  if (!name.value)  name.value  = localStorage.getItem('name');
  if (!email.value) email.value = localStorage.getItem('email');
  if (!url.value)   url.value   = localStorage.getItem('url');
  if (localStorage.getItem('rememberMe')) rememberMe.checked = true;

  var form = document.getElementById('comment-form');
  form.addEventListener("submit", function(event) {
    if (rememberMe.checked) {
      localStorage.setItem('name', name.value);
      localStorage.setItem('email', email.value);
      localStorage.setItem('url', url.value);
      localStorage.setItem('rememberMe', true);
    } else {
      localStorage.removeItem('rememberMe');
    }
  });

  var clearInfo  = document.getElementById('clear-info');
  clearInfo.addEventListener("click", function(event) {
    name.value = email.value = url.value = '';
    localStorage.removeItem('name');
    localStorage.removeItem('email');
    localStorage.removeItem('url');
    localStorage.removeItem('rememberMe');
    rememberMe.checked = false;
  });

  var enablePreview = function(event) {
    if (preview) preview.disabled = !comment.value;

    if (submit) {
      submit.disabled = !comment.value
      submit.value = ((comment.value == baseline) ? 'Submit' : 'Preview');
      submit.setAttribute('name', submit.value.toLowerCase());
    }
  }
  enablePreview();
  comment.addEventListener("input", enablePreview);

  comment.readOnly = false;
  if (edit) {
    edit.parentNode.removeChild(edit);
    document.querySelector('h2').textContent = 'Edit your comment';
  }

  document.querySelector('.storage-options').style.display = 'inline';
});
