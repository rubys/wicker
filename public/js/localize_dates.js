// Parse an HTML5-liberalized version of RFC 3339 datetime values
Date.parseRFC3339 = function (string) {
    var date=new Date(0);
    var match = string.match(/(\d{4})-(\d\d)-(\d\d)\s*(?:[\sT]\s*(\d\d):(\d\d)(?::(\d\d))?(\.\d*)?\s*(Z|([-+])(\d\d):(\d\d))?)?/);
    if (!match) return;
    if (match[2]) match[2]--;
    if (match[7]) match[7] = (match[7]+'000').substring(1,4);
    var field = [null,'FullYear','Month','Date','Hours','Minutes','Seconds','Milliseconds'];
    for (var i=1; i<=7; i++) if (match[i]) date['setUTC'+field[i]](match[i]);
    if (match[9]) date.setTime(date.getTime()+
        (match[9]=='-'?1:-1)*(match[10]*3600000+match[11]*60000) );
    return date.getTime();
}

// Localize the display of <time> elements
function localizeDates() {
  var sections = document.querySelectorAll('section');
  var section = null;
  var lastdate = '';
  var now = new Date();

  var times = document.querySelectorAll('time');
  for (var i=0; i<times.length; i++) {
    var time = times[i];

    if (time.getAttribute('title') == "GMT") {
      var date = new Date(Date.parseRFC3339(time.getAttribute('datetime')));
      if (!date.getTime()) return;

      // replace title attribute and text value with localized versions
      if (time.getAttribute('datetime').length <= 16) {
        // date only
        time.removeAttribute('title');
        time.textContent = date.toLocaleDateString();
      } else if (time.textContent.length < 10 || now-date < 86400000) {
        // time only
        time.setAttribute('title', date.toUTCString());
        time.textContent = date.toLocaleTimeString();
      } else {
        // full datetime
        time.setAttribute('title', time.textContent + ' GMT');
        time.textContent = date.toLocaleString();
      }

      // Make webkit time zone information more compact
      time.textContent = 
        time.textContent.replace(/ GMT(-\d\d\d\d) \(.*\)$/, '');

      // insert/remove date headers to reflect date in local time zone
      var article = time.parentNode;
      while (article && article.tagName.toLowerCase() != 'article') {
        article = article.parentNode;
      }

      if (article) {
        if (article.parentNode.tagName.toLowerCase() == 'section') {
          var displayDate = date.toLocaleDateString();
          var hr = document.createElement('hr');
          if (displayDate != lastdate) {
            var datetime = time.getAttribute('datetime').substring(0,10);

            var time = document.createElement('time');
            time.setAttribute('datetime', datetime);
            time.textContent = displayDate;

            var h2 = document.createElement('h2');
            h2.appendChild(time);

            var header = document.createElement('header');
            header.appendChild(h2);

            section = document.createElement('section');
            section.appendChild(header);

            sections[0].parentNode.insertBefore(section, sections[0]);
            sections[0].parentNode.insertBefore(hr, sections[0]);

            lastdate = displayDate;
          } else {
            section.appendChild(hr);
          }

          var nextElement = article.nextElementSibling;
          if (nextElement && nextElement.tagName.toLowerCase() == 'hr') {
            nextElement.parentNode.removeChild(nextElement);
          }

          section.appendChild(article);
        }
      }
    }
  }

  // remove original sections
  if (lastdate != '') {
    for (var i=0; i<sections.length; i++) {
      if (sections[i].children.length == 1) {
        if (sections[i].children[0].tagName.toLowerCase() == 'header') {
          sections[i].parentNode.removeChild(sections[i]);
        }
      }
    }
  }
}

document.addEventListener("DOMContentLoaded", function(event) {
  localizeDates();
});
