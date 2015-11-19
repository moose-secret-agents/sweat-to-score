# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#savePosition').on 'click', ->
    savePlayerPositions()

  initFaces()
  initTabs()
  initPlayers()

$(document).ready(ready)
$(document).on('page:load', ready)

initFaces = ->
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

initTabs = ->
  tabs = $('.tab-content').children().hide()
  $('#players-tab').show()
  $("a[data-toggle='tab'").each (index, element) ->
    $(element).on 'click', ->
      tab_id = $(element).attr('href')
      tabs.hide()
      $(tab_id).show()

initPlayers = ->
  # Make players draggable
  $('.draggable').draggable(containment: '#field')

sendPositions = (positions) ->
  team_id = $('#bank').data('team-id')
  $.post("/teams/#{team_id}/positions", { positions: positions })

savePlayerPositions = ->
  positions = {}
  $('.player').each (index, element) ->
    id = $(element).data('player-id')
    pos =
      top: $(element).offset().top - $('#field').offset().top
      left: $(element).offset().left - $('#field').offset().left
    positions[id] = pos

  sendPositions(positions)