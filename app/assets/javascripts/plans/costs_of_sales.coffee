@update_costs_of_sales_table = ->
  recurringfill_costs_of_sales()

@recurringfill_costs_of_sales = ->
  val = $(".js-recurring_costs").val()
  last_value = ""
  last_value_index = ""
  $(".js-plan-row .js-col-direct_costs").each (i) ->
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

  return unless page("plans", "index") && $(".js-dimension").val() == "costs_of_sales"
