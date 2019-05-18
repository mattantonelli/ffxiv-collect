document.addEventListener 'turbolinks:load', (event) ->
  if typeof gtag is 'function'
    gtag('config', window._ga_tid, { 'page_location': event.data.url })
