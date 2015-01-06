document.addEventListener("DOMContentLoaded", function(event) {
  var name = document.getElementById('name');
  var email = document.getElementById('email');
  var url = document.getElementById('url');
  var rememberMe = document.getElementById('remember-me');

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

  document.querySelector('.storage-options').style.display = 'inline';
});