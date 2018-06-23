$(document).on "turbolinks:load", ->

  return unless page("plans", "index") || page("plans", "plan_method")

  show_per_unit = ->
    if $("#sales_method-absolute_amounts").is(":checked")
      $("#costs_method-per_unit").parents(".radioChoice").addClass("disabled")

      if $("#costs_method-per_unit").is(":checked")
        $("#costs_method-absolute_amounts").prop("checked", true)

    else
      $("#costs_method-per_unit").parents(".radioChoice").removeClass("disabled")

  show_per_unit()

  # Special rule for planning methods
  $(".radioChoice").on "click", (e) ->
    show_per_unit()

    if $(this).find("input").hasClass("disabled")
      e.preventDefault()
