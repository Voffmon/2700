$(document).on "turbolinks:load", ->

  return unless page("transactions", "index") || page("transactions", "edit")

  # Show transaction form
  $(".js-show-transaction-form").click ->
    $(".transactionForm").slideDown(200)
    $(".js-year").focus()
    $(this).hide()

  # Hide transaction form
  $(".js-hide-transaction-form").click ->
    $(".transactionForm").slideUp(200)
    $(".js-show-transaction-form").fadeIn()
    return false

  # Decide whether to show the modal
  $(".js-new-transaction-form").on "submit", (e) ->
    if $(".js-year option:selected").data("unlocked") == "unlocked"
      $(".js-modal-year").text( $(".js-year option:selected").text())
      $(".modal-bg").fadeIn(200)
      $(".modal").fadeIn(200)
      e.preventDefault()
      return false

  # Cancel locked transaction modal
  $(".js-modal-cancel").click ->
    $(".modal-bg").fadeOut(200)
    $(".modal").fadeOut(200)
    return false

  # Submit locked transaction modal
  $(".js-modal-submit").click ->
    $(".js-year option:selected").data("unlocked", "")
    $(".js-new-transaction-form").submit()
    $(".modal-bg").fadeOut(200)
    $(".modal").fadeOut(200)

  # Create transaction callback
  $(".js-new-transaction-form").on "ajax:success", (e, data) ->
    $(".js-transactions").show()
    $(".js-no-transactions").hide()
    $(".js-transactions").prepend(data.html)
    $(".js-transaction-title, .js-transaction-note, .js-transaction-amount").val("")

  # Delete transaction callback
  $(".js-transactions").on "ajax:success", ".js-delete-transaction", (e, data) ->
    $(this).parents(".js-transaction").slideUp(300)

  # Compute number of days when changing year of month
  $(".js-year, .js-month").change ->
    $.get(
      $(".js-number-of-days-url").val(),
      {month: $(".js-month").val(), year: $(".js-year").val()},
      (data) ->
        $(".js-day option:not(:first)").remove()
        for day in [1..data.days]
          $(".js-day").append("<option value=\"" + day + "\">" + day + "</option>")
    )

  # Get positions for year
  $(".js-year").change ->
    $.get(
      $(".js-positions-for-year-url").val(),
      {year: $(".js-year").val(), venture_id: $(".js-venture-id").val()},
      (data) ->
        $(".js-positions").empty()
        for position in data.positions
          $(".js-positions").append("<option value=\"" + position[1] + "\">" + position[0] + "</option>")
    )

  # Compute net amount
  $(".js-transaction-amount, .js-transaction-vat").keyup ->
    amount = parseFloat($(".js-transaction-amount").val().replace(/[\,]/g, "."))
    vat    = parseInt($(".js-transaction-vat").val().replace(/[\,]/g, "."))

    $(".js-transaction-net-amount").val(String(amount - amount * vat / 100).replace(/[\.]/g, ","))
    format_decimal_field($(".js-transaction-net-amount"))
