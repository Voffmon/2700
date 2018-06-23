
# Autofill helper
@autofill = (elems, grow_factor_elem) ->
  last_value = null
  elems.each ->
    value = parseFloat($(this).val().replace(/[\,]/g, ".")) || ""

    if grow_factor_elem != null
      grow_factor = parseInt(grow_factor_elem.val()) || ""
    else
      grow_factor = 0

    is_user_generated = $(this).parents(".plan-cell").find(".js-is-user-generated").is(":checked")

    if !is_user_generated && last_value != null
      $(this).val(String(last_value + last_value * grow_factor / 100).replace(/[\.]/g, ","))

    unless isNaN(parseFloat($(this).val()))
      last_value = parseFloat($(this).val())

$(document).on "turbolinks:load", ->

  return unless page("plans", "index")

  # Select year
  $(".js-change-year").on "change", ->
    Turbolinks.visit($(this).find("option:selected").data("url"), {action: "replace"})

  # Toggle note
  $(".js-toggle-note").on "click", ->
    note = $(this).parents(".plan-cell").next()
    note.slideToggle(200)
    if $(this).is(":visible")
      note.find("textarea").focus()
    return false

  # Decide which note icon should be displayed
  $(".plan-note textarea").on "keyup", ->
    cell = $(this).parents(".plan-note").prev()
    if $(this).val() == ""
      cell.find(".plan-editNoteLink").hide()
      cell.find(".plan-addNoteLink").show()
    else
      cell.find(".plan-editNoteLink").show()
      cell.find(".plan-addNoteLink").hide()

  # Everytime a table field is changed, the user generated field gest reevaluated
  $(".js-plan-row input[type=text], .js-plan-row-forecast input[type=text]").on "keyup", ->
    if $(this).val() == ""
      $(this).parent().removeClass("plan-cell--breakpoint").find(".js-is-user-generated").prop("checked", false)
    else
      $(this).parent().addClass("plan-cell--breakpoint").find(".js-is-user-generated").prop("checked", true)


  # If plan gets saved, make sure to compute table first
  $(document).on "submit", ".js-plan-form", ->
    update_table()

  # Always compute total amount if one plan cell changes
  compute_total_amounts = ->

    # Init total amounts
    total_amounts = (0 for [1..$(".js-plan-row:first input[type=text]").length])
    total_amounts_forecast = (0 for [1..$(".js-plan-row-forecast:first input[type=text]").length])

    # Compute values for each row
    $(".js-plan-row").each ->
      $(this).find("input[type=text]").each (i) ->
        total_amounts[i] += parseFloat($(this).val().replace(/[\,]/g, ".")) || 0

    # Compute values for each forecast row
    $(".js-plan-row-forecast").each ->
      $(this).find("input[type=text]").each (i) ->
        total_amounts_forecast[i] += parseFloat($(this).val().replace(/[\,]/g, ".")) || 0

    # Print total amounts
    $(".js-total").each (i) ->
      $(this).text(String(total_amounts[i]).replace(/[\.]/g, ","))

    $(".js-total-forecast").each (i) ->
      $(this).text(String(total_amounts_forecast[i]).replace(/[\.]/g, ","))

    # Formatting for totals
    $(".js-total, .js-total-forecast").each ->
      if $(this).hasClass("js-decimal")
        format_decimal_field($(this))
      else if $(this).hasClass("js-integer")
        format_integer_field($(this))

    # Formatting for table cells
    $(".js-plan-row, .js-total-forecast").each ->
      $(this).find("input[type=text]").each ->
        return if $(this).val() == ""
        if $(this).hasClass("js-decimal")
          format_decimal_field($(this))
        else if $(this).hasClass("js-integer")
          format_integer_field($(this))


  # Start document by updating table
  update_table = ->
    switch $(".js-dimension").val()
      when "sales"          then update_sales_table()
      when "costs_of_sales" then update_costs_of_sales_table()
      when "costs"          then update_costs_table()
      when "investments"    then update_investments_table()
      when "funding"        then update_funding_table()

    compute_total_amounts()
  update_table()

  $(".js-recurring_costs").change ->
    update_table()

  $(".js-recurring_funding").change ->
    update_table()


  # Update table, timeout to be sure, maths completed
  $(document).on(
      blur: ->
        setTimeout ->
          update_table()
        , 10
      ,
      keypress: (e) ->
        if e.which == 13
          setTimeout ->
            update_table()
          , 10
  , ".js-plan-row input, .js-plan-row-forecast, .js-settings input")

  # If focus is on table line, then set visual cue
  $(document).on "focus", ".js-plan-row input", ->
    $(this).parents(".js-plan-row, .js-plan-row-forecast").find(".yearLabel").addClass("current")

  # If table line is blurred, then remove visual cue
  $(document).on "blur", ".js-plan-row input", ->
    $(".js-plan-row .yearLabel, .js-plan-row-forecast .yearLabel").removeClass("current")
