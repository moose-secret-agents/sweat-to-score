# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#savePosition').on 'click', (event) -> savePlayerPositions()
  $('#markKeeper').on 'click', (event) -> markKeeper()

  initFaces()
  initTabs()
  initPlayers()

$(document).ready(ready)
$(document).on('page:load', ready)

initFaces = ->
  $(".avatar-image").each (index, element) ->
    id = $(element).attr('id')
    face = $(element).data('face')
    fitness = $(element).data('fitness')
    face.fatness = fitness

    face.mouth.id = switch
      when talent < 20 then 1
      when talent < 40 then 2
      when talent < 60 then 3
      when talent < 80 then 4
      else 5

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

  # Update positions
  $('.player').each (index, element) ->
    pos = $(element).data('position')
    $(element).css('left', pos[0])
    $(element).css('top', pos[1])

sendPositions = (positions) ->
  team_id = $('#football-field').data('team-id')
  $.post("/teams/#{team_id}/positions", { positions: positions })

savePlayerPositions = ->
  positions = {}
  $('.player').each (index, element) ->
    id = $(element).data('player-id')
    pos =
      top: $(element).offset().top - $('#football-field').offset().top
      left: $(element).offset().left - $('#football-field').offset().left
    positions[id] = pos

  sendPositions(positions)

markKeeper = ->
