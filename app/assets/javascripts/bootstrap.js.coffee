ready =  ->
  $("a[rel~=popover], .has-popover").popover(html: true)
  $("a[rel~=tooltip], .has-tooltip").tooltip()

$(document).ready(ready)
$(document).on('page:load', ready)
