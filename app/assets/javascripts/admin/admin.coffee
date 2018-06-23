# Call ready on initial page load and turbolink
$(document).on 'turbolinks:load', ->

  # Only proceed if current page is edit account
  return unless page("admin", "users")

  # Handle user approval
  $(".user-state-link").on "ajax:success", (e, data) ->
    $(this).closest("tr").removeClass("approved blocked").addClass(data.state)
    $(this).closest("tr").find(".user-state-link").show();
    $(this).hide();
