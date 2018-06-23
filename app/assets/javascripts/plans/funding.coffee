@update_funding_table = ->
  recurringfill_funding()

  $(".js-plan-row").each ->

    if $(this).find(".js-col-funding").val() != undefined
      col_funding = parseFloat($(this).find(".js-col-funding").val()) || 0

    if $(this).find(".js-col-repayment").val() != undefined
      col_repayment = parseInt($(this).find(".js-col-repayment").val()) || 0

    $(this).find(".js-col-saldo").val(col_funding - col_repayment)

@recurringfill_funding = ->
  val = $(".js-recurring_funding").val()
  last_value = ""
  last_value_index = ""
  $(".js-plan-row .js-col-repayment").each (i) ->
    is_user_generated = $(this).parent().find(".js-is-user-generated").is(":checked")
    if !is_user_generated
      if (i - last_value_index)%val == 0
        $(this).val(last_value)
      else
        $(this).val("")

    if $(this).val() != ""
      last_value = $(this).val()
      last_value_index = i


$(document).on "turbolinks:load", ->

  return unless page("plans", "index") && $(".js-dimension").val() == "funding"
