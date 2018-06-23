
@update_sales_table = ->

  autofill($(".js-plan-row input.js-col-quantity"), $(".js-sales_growth"))
  autofill($(".js-plan-row-forecast input.js-col-quantity"), $(".js-sales_growth_forecast"))

  $(".js-plan-row, .js-plan-row-forecast").each ->

    # Try to parse input fields
    if $(this).find(".js-col-quantity").val() != undefined
      col_quantity = parseFloat($(this).find(".js-col-quantity").val().replace(/[\,]/g, ".")) || 0

    if $(this).find(".js-col-quantity").val() != undefined
      col_sales = parseFloat($(this).find(".js-col-quantity").val().replace(/[\,]/g, ".")) || 0

    if $(this).find(".js-col-direct_costs").val() != undefined
      col_costs = parseFloat($(this).find(".js-col-direct_costs").val().replace(/[\,]/g, ".")) || 0

    if $(".js-price").val() != undefined
      price = parseFloat($(".js-price").val().replace(/[\,]/g, ".")) || 0

    if $(".js-direct_costs").val() != undefined
      costs = parseFloat($(".js-direct_costs").val().replace(/[\,]/g, ".")) || 0

    # Sales method Quantity times price
    if $(".js-sales-method").val() == "quantity_times_price"
      $(this).find(".js-col-turnover").val(String(col_quantity * price).replace(/[\.]/g, ","))

      if $(".js-costs-method").val() == "per_unit"
        $(this).find(".js-col-direct_costs").val(String(col_quantity * costs).replace(/[\.]/g, ","))
        $(this).find(".js-col-marginal_return").val(String((col_quantity * price) - (col_quantity * costs)).replace(/[\.]/g, ","))

      else if $(".js-costs-method").val() == "absolute_amounts"
        $(this).find(".js-col-marginal_return").val(String((col_quantity * price) - col_costs).replace(/[\.]/g, ","))

    # Sales method Absolute amounts
    else if $(".js-sales-method").val() == "absolute_amounts"
      if $(".js-costs-method").val() == "absolute_amounts"
        $(this).find(".js-col-marginal_return").val(String(col_sales - col_costs).replace(/[\.]/g, ","))


$(document).on "turbolinks:load", ->

  return unless page("plans", "index") && $(".js-dimension").val() == "sales"

  $(".js-price").keyup ->

    return unless $(".js-sales-method").val() == "quantity_times_price" && $(".js-costs-method").val() == "per_unit"

    price  = parseInt($(".js-price").val().replace(/[\,]/g, "."))
    costs  = parseInt($(".js-direct_costs").val().replace(/[\,]/g, "."))
    margin = parseInt($(".js-net_margin").val().replace(/[\,]/g, "."))

    if isNaN(price) || price == 0
      $(".js-net_margin").val("")
      return

    if !isNaN(costs)
      $(".js-net_margin").val(String(100 * (price - costs) / price).replace(/[\.]/g, ","))
      format_decimal_field($(".js-net_margin"))
    else if !isNaN(margin)
      $(".js-direct_costs").val(String(price - margin * price / 100).replace(/[\.]/g, ","))
      format_decimal_field($(".js-direct_costs"))

  $(".js-direct_costs").keyup ->

    return unless $(".js-sales-method").val() == "quantity_times_price" && $(".js-costs-method").val() == "per_unit"

    price  = parseInt($(".js-price").val().replace(/[\,]/g, "."))
    costs  = parseInt($(".js-direct_costs").val().replace(/[\,]/g, "."))
    margin = parseInt($(".js-net_margin").val().replace(/[\,]/g, "."))

    if isNaN(costs) || price == 0
      $(".js-net_margin").val("")
      return

    if !isNaN(price)
      $(".js-net_margin").val(String(100 * (price - costs) / price).replace(/[\.]/g, ","))
      format_decimal_field($(".js-net_margin"))
    else if !isNaN(margin) && margin != 100
      $(".js-price").val(String(-100 * costs / (margin - 100)).replace(/[\.]/g, ","))
      format_decimal_field($(".js-price"))

  $(".js-net_margin").keyup ->

    return unless $(".js-sales-method").val() == "quantity_times_price" && $(".js-costs-method").val() == "per_unit"

    price  = parseInt($(".js-price").val().replace(/[\,]/g, "."))
    costs  = parseInt($(".js-direct_costs").val().replace(/[\,]/g, "."))
    margin = parseInt($(".js-net_margin").val().replace(/[\,]/g, "."))
    return if isNaN(margin)
    if !isNaN(price)
      $(".js-direct_costs").val(String(price - margin * price / 100).replace(/[\.]/g, ","))
      format_decimal_field($(".js-direct_costs"))

  $(".js-net_margin").blur ->

    return unless $(".js-sales-method").val() == "quantity_times_price" && $(".js-costs-method").val() == "per_unit"

    price  = parseInt($(".js-price").val().replace(/[\,]/g, "."))
    costs  = parseInt($(".js-direct_costs").val().replace(/[\,]/g, "."))
    margin = parseInt($(".js-net_margin").val().replace(/[\,]/g, "."))
    return if isNaN(margin) && margin != 100
    if isNaN(price)
      $(".js-price").val(String(-100 * costs / (margin - 100)).replace(/[\.]/g, ","))
      format_decimal_field($(".js-price"))
