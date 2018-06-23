# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@format_decimal_field = (elem) ->
  val = if elem.is("input") then elem.val() else elem.text()

  return if val == ""
  val = val.replace(/[^\d\,\-]/g, "")
  val = val.replace(/[\,]/g, ".")
  val = String((Math.round(val * 100) / 100).toFixed(2))
  val = val.replace(/[\.]/g, ",")

  if elem.is("input") then elem.val(val) else elem.text(val)


@format_integer_field = (elem) ->
  val = if elem.is("input") then elem.val() else elem.text()

  return if val == ""
  val = val.split(',')[0]
  val = val.replace(/[^\d\-]/g, "")

  if elem.is("input") then elem.val(val) else elem.text(val)


@evaluate_maths = (elem) ->
  if /^[\d\+\-\=\*\/\(\)\,\s]+$/.test(elem.val())
    elem.val(elem.val().replace(/[\=]/g, ""))
    elem.val(elem.val().replace(/[\,]/g, "."))
    elem.val(eval(elem.val()))
    elem.val(elem.val().replace(/[\.]/g, ","))


$(document).on "turbolinks:load", ->

  # Always set cursor to the first form field
  $("form input[type=text]:first").focus()

  # Loading animation for submit buttons
  $(document).on "submit", "form", ->
    if $(".form-element input[type=submit]").length > 0
      $(".form-element input[type=submit]").hide().parents(".form-element").next().find("button").show()

  # Init tooltips
  $("[data-toggle=\"tooltip\"]").tooltip()

  # Fields with class .js-maths have the abilitiy to compute simple maths
  $(document).on(
      blur: ->
        evaluate_maths($(this))
      ,
      keypress: (e) ->
        if e.which == 13
          evaluate_maths($(this))
          e.preventDefault()
  , ".js-maths")

  # Fields with class .js-decimal can only have two digits after comma
  $(document).on(
      blur: ->
        format_decimal_field($(this))
      ,
      keypress: (e) ->
        if e.which == 13
          format_decimal_field($(this))
          e.preventDefault()
  , ".js-decimal")

  # Fields with class .js-integer can only have integer content
  $(document).on(
      blur: ->
        format_integer_field($(this))
      ,
      keypress: (e) ->
        if e.which == 13
          format_integer_field($(this))
          e.preventDefault()
  , ".js-integer")
