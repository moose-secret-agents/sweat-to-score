# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#savePosition').on 'click', (event) -> savePlayerPositions()

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
    stamina = $(element).data('stamina')
    face.fatness = fitness

    face.mouth.id = switch
      when stamina < 20 then 1
      when stamina < 40 then 2
      when stamina < 60 then 3
      when stamina < 80 then 4
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
  $field = $('#field')

  simFieldDim = [100, 60]
  fieldDim = [940, 598]

  # Make players draggable
  $('.draggable').draggable(revert: 'invalid')
  $('#field').droppable
    accept: '.player'
    drop: onDropField
  $('#bank').droppable
    accept: '.player'
    drop: onDropBank

  # Update positions
  $('#field > .player').each (index, element) ->
    $el = $(element)
    pos = $el.data('position')
    $el.css
      position: 'absolute'
      left: (pos[0] / simFieldDim[0] * fieldDim[0]) - 50
      top: (pos[1] / simFieldDim[1] * fieldDim[1]) - 50

sendPositions = (positions) ->
  team_id = $('#football-field').data('team-id')
  $.post("/teams/#{team_id}/positions", { positions: positions }).success(() -> alert("Positions updated...")).fail(() -> alert("Not allowed to update positions"))

savePlayerPositions = ->
  $field = $('#field')

  simFieldDim = [100, 60]
  fieldDim = [940, 598]

  positions = {}
  $('#bank > .player').each (index, element) ->
    id = $(element).data('player-id')
    pos =
      top: -1
      left: -1
    positions[id] = pos

  $('#field > .player').each (index, element) ->
    id = $(element).data('player-id')
    pos =
      left: ($(element).position().left + 50) / fieldDim[0] * simFieldDim[0]
      top: ($(element).position().top + 50) / fieldDim[1] * simFieldDim[1]
    positions[id] = pos

  [res, confirm, msg] = validatePlayers(positions)

  if !res and !confirm
    alert msg
  else if !res and confirm
    if window.confirm(msg)
      sendPositions(positions)
  else
    sendPositions(positions)

onDropField = (e, ui) ->
  $draggable = ui.draggable
  $field = $('#field')

  parent = $draggable.parent()

  fieldPos = $field.offset()

  posPrev = { top: $draggable.offset().top - fieldPos.top, left: $draggable.offset().left - fieldPos.left }

  $draggable.appendTo(this)

  $draggable.css
    position: 'absolute'
    top: posPrev.top
    left: posPrev.left

  markKeeper()

onDropBank = (e, ui) ->
  $draggable = ui.draggable
  $draggable.appendTo(this)
  $draggable.css
    position: 'relative'
    top: 0
    left: 0

  markKeeper()

markKeeper = ->
  $field = $('#field')
  $players = $('#field > .player')

  lefts = _.map $players, (e) ->
    $(e).position().left

  min = _.min lefts

  $players.each (i, e) ->
    if ($(e).position().left == min)
      $players.removeClass('keeper')
      $(e).addClass('keeper')

validatePlayers = (positions) ->
  fieldPlayers = $('#field > .player')

  return [false, false, 'Cannot have more than 11 players on the field!'] if fieldPlayers.size() > 11
  return [false, true, 'Do you really want to play with less than 11 players?'] if fieldPlayers.size() < 11
  return [true, false, 'Everything ok']
