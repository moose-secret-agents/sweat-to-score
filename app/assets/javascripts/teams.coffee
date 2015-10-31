# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(".avatar-image").each (index, element) ->
    id = $(element).attr('id')
    face = $(element).data('face')
    talent = $(element).data('talent')
    face.fatness = talent

    if(talent < 20)
      face.mouth.id = 1
    else if(talent < 40)
      face.mouth.id = 2
    else if(talent < 60)
      face.mouth.id = 3
    else if(talent < 80)
      face.mouth.id = 4
    else face.mouth.id = 5

    faces.display(id, face)

$(document).ready(ready)
$(document).on('page:load', ready)

