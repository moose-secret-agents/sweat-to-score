# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".avatar-image").each (index, element) ->
    id = $(element).attr('id')
    faces.generate(id)

$(document).ready(ready)
$(document).on('page:load', ready)

