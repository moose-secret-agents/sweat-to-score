# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.gif-button').on 'click', ->
    $btn = $(this)
    target = $btn.data('target_id')
    imgurl = $btn.data('url')
    $img = $("#"+target).html("<img src=#{imgurl} class=\"matchgif\" >")
    $btn.remove()

$(document).ready(ready)
$(document).on('page:load', ready)
