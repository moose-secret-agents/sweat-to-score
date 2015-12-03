ready =  ->

  # Initialize Datetime Picker
  $('#datetimepicker1').datetimepicker
    format: 'YYYY-MM-DD HH:mm:ss'

  # Initialize Popovers and Tooltips
  $("a[rel~=popover], .has-popover")
    .popover(html: true, container: 'body')
    .on("show.bs.popover", -> $(this).data("bs.popover").tip().css(minWidth: "300px"))
  $("a[rel~=tooltip], .has-tooltip").tooltip()


$(document).ready(ready)
$(document).on('page:load', ready)
