ready =  ->

  $('#datetimepicker1').datetimepicker
    format: 'YYYY-MM-DD HH:mm:ss'


$(document).ready(ready)
$(document).on('page:load', ready)
