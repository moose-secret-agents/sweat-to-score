# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".avatar-image").each (index, element) ->
    id = $(element).attr('id')
    face = faces.generate()
    talent = $(element).data('talent')
    face.fatness = talent
#    face.color = 'blue'

    faces.display(id, face)


$(document).ready(ready)
$(document).on('page:load', ready)

