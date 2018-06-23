$(document).on "turbolinks:load", ->

  return unless page("ventures", "index")

  # Delete event callback
  $(".js-ventures").on "ajax:success", ".js-delete-venture", (e, data) ->
    $(this).parents(".js-venture").fadeOut(300)
    if $(".js-venture").length == 0
      $(".js-ventures, .js-no-ventures").toggle()
