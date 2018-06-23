@update_investments_table = ->
  #

$(document).on "turbolinks:load", ->

  return unless page("plans", "index") && $(".js-dimension").val() == "investments"

  #
