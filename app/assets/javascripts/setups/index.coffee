$(document).on "turbolinks:load", ->

  return unless page("setups", "index") || page("setups", "archived_positions") || page("setups", "deleted_positions")

  # Open new setup modal
  $(".js-open-new-setup-modal").click ->
    $(".modal-bg").fadeIn(200)
    $(".js-copy-setup-modal").fadeIn(200)
    return false

  # Open reset setup modal
  $(".js-open-reset-setup-modal").click ->
    $(".modal-bg").fadeIn(200)
    $(".js-reset-setup-modal").fadeIn(200)
    return false

  # Cancel new setup modal
  $(".js-modal-mode").change ->
    $(this).parents(".modal").find(".js-modal-from-year").parents(".form-element").toggle($(this).val() != "scratch")
    $(this).parents(".modal").find(".js-modal-copy-to-title").toggle($(this).val() != "scratch")

  # Create new setup
  $(".js-modal-submit").click ->
    $(this).parents("form").submit()

  # Cancel new setup modal
  $(".js-modal-cancel").click ->
    $(".modal-bg").fadeOut(200)
    $(".modal").fadeOut(200)
    return false

  # Show new category form
  $(".js-dimension").on "click", ".js-show-category-form", ->
    $(this).hide().next().show().find(".js-category-name").focus()
    return false

  # Show edit category form
  $(".js-dimension").on "click", ".js-show-edit-category-form", ->
    $(this).hide().next().show().find(".js-category-name").select()
    return false

  # Click away from category form closed the fields
  $(".js-dimension").on "blur", ".js-category-name", (e) ->
    if (!e.relatedTarget || e.relatedTarget.type != "submit")
      $(this).parents(".js-new-category-form, .js-edit-category-form").hide().prev().show()

  # Create category callback
  $(".js-dimension").on "ajax:success", ".js-new-category-form", (e, data) ->
    $(this).hide().prev().show()
    $(this).find(".js-category-name").val("")
    $(this).parents(".js-dimension").find(".js-categories").append(data.html)
    init_positions()
    init_category_positions()

  # Update category callback
  $(".js-dimension").on "ajax:success", ".js-edit-category-form", (e, data) ->
    $(this).hide().prev().text(data.name).show()

  # Delete category callback
  $(".js-dimension").on "ajax:success", ".js-delete-category", (e, data) ->
    $(this).parents(".js-category").hide()
    $(this).parents(".js-dimension").find(".js-category:first").replaceWith(data.html)
    init_category_positions()

  # Switcher element for setting active / inactive state
  $(".js-dimension").on "change", ".js-switch-active-inactive", ->
    if $(this).is(":checked")
      $(this).parents(".js-position").find(".js-set-active").click()
    else
      $(this).parents(".js-position").find(".js-set-inactive").click()

  # Toggle position active state
  $(".js-dimension").on "click", ".js-set-state", ->
    $(this).parents(".js-position").removeClass("active inactive archived deleted").addClass($(this).data("state"))

  # Toggle position active state callback
  $(".js-dimension").on "ajax:success", ".js-set-state", (e, data) ->
    $(this).parents(".js-position").find(".js-active-state").text(data.active_state)

  # Unarchive / Restore category callback
  $(document).on "ajax:success", ".js-unarchive, .js-restore", (e, data) ->
    $(this).parents(".positionList-item").fadeOut(200)

  # Restore scroll position if back-to-setup link is clicked
  active_dimension = false
  if $(".active-dimension").val() != ""
    $(".primaryContent--scroll").scrollTop($(".js-dimension[data-dimension=" + $(".active-dimension").val() + "]").offset().top)
    active_dimension = $('.js-dimension').index($(".js-dimension[data-dimension=" + $(".active-dimension").val() + "]"))

  # Accordion for categories and positions
  $(".js-accordion").accordion(
    heightStyle: "content",
    collapsible: true,
    animate: 300,
    header: ".dimension-title",
    active: active_dimension,

    activate: (event, ui) ->

      # If all dimensions are closed remove url state
      if $(".ui-state-active").length == 0
        window.history.replaceState(window.history.state, '', $(".root-url").val())

      # Push state when opening dimension
      else
        window.history.replaceState(window.history.state, '', ui.newHeader.parents(".js-dimension").data("url"))
  )

  # Sortable positions
  init_positions = ->
    $('.js-positions:not(.js-unmovable)').each ->

      positions = $(this)
      Sortable.create($(this).get(0), {
        animation: 150,
        ghostClass: "position-ghost",
        draggable: ".js-position",

        # Enable dragging across categories
        group: positions.parents(".js-dimension").data("dimension")

        scroll: true,
        scrollSensitivity: 50,
        scrollSpeed: 10,

        # If sorting has been updated, perform an ajax request
        onUpdate: () ->
          category = positions.parents(".js-category")

          # Collect all positions ids for the category
          ids = category.find(".js-position").map ->
            return $(this).data("id")

          # Send it to the server
          update_position_order(category.data("id"), category.data("id"), ids.toArray(), ids.toArray())

        # If group changed update both categories
        onAdd: (e) ->
          from = $(e.from).parents(".js-category")
          to =  $(e.item).parents(".js-category")

          # Collect all positions ids for the source and the target category
          from_ids = from.find(".js-position").map ->
            return $(this).data("id")

          to_ids = to.find(".js-position").map ->
            return $(this).data("id")

          # Send it to the server
          update_position_order(from.data("id"), to.data("id"), from_ids.toArray(), to_ids.toArray())
      })

  init_positions()

  # Send positions to the server
  update_position_order = (from, to, from_ids, to_ids) ->
    $.ajax(
      type: "PATCH",
      url:  $(".update-position-order-url").val(),
      data: {
          from: from,
          to: to,
          from_ids: from_ids,
          to_ids: to_ids
      }
    )

  # Move category up
  $(".js-dimension").on "click", ".js-category-up", ->
    $(this).parents(".js-category").prev().before($(this).parents(".js-category")[0].outerHTML)
    update_category_order($(this).parents(".js-categories"))
    $(this).parents(".js-category").remove()
    init_positions()
    init_category_positions()
    return false

  # Move category down
  $(".js-dimension").on "click", ".js-category-down", ->
    $(this).parents(".js-category").next().after($(this).parents(".js-category")[0].outerHTML)
    update_category_order($(this).parents(".js-categories"))
    $(this).parents(".js-category").remove()
    init_positions()
    init_category_positions()
    return false

  # Resets all category up / down links
  init_category_positions = ->
    $(".js-dimension").each ->
      $(this).find(".js-category-up, .js-category-down").show()
      $(this).find(".js-category:eq(1) .js-category-up").hide()
      $(this).find(".js-category:last .js-category-down").hide()
  init_category_positions()

  update_category_order = (categories) ->
    ids = $(categories).find(".js-category").map ->
      return $(this).data("id") if $(this).data("id") != ""

    $.ajax(
      type: "PATCH",
      url:  $(".update-category-order-url").val(),
      data: {
        ids: ids.toArray()
      }
    )
