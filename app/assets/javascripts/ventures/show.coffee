$(document).on "turbolinks:load", ->

  return unless page("ventures", "show")

  # Change year
  $(".js-select-year").on "click", ".dropdown-menu a",  ->

    new_year = $(this).data("year")

    # Change year in mode change links
    $(".js-mode-plan").attr("href", $(".js-mode-plan").attr("href").replace($(".js-selected-year").text() + "/plan", new_year + "/plan"))
    $(".js-mode-performance").attr("href", $(".js-mode-performance").attr("href").replace($(".js-selected-year").text() + "/performance", new_year + "/performance"))
    $(".js-mode-forecast").attr("href", $(".js-mode-forecast").attr("href").replace($(".js-selected-year").text() + "/forecast", new_year + "/forecast"))
    $(".js-mode-compare-to-plan").attr("href", $(".js-mode-compare-to-plan").attr("href").replace($(".js-selected-year").text() + "/compare_to_plan", new_year + "/compare_to_plan"))

    # TODO: Compare to year

    $(this).parents(".js-select-year").removeClass("open")
    $(".js-selected-year").text($(this).text())

  # Change year callback
  $(".js-select-year").on "ajax:success", ".dropdown-menu a", (e, data) ->
    $(".js-analysis").html(data.html)
    init_main_chart()
    init_tree_table()

  # Change mode
  $(".js-change-mode").on "click", "li a",  ->

    new_mode = $(this).data("mode")

    # Change year
    $(".js-select-year .dropdown-menu a").each ->
      if new_mode == "plan"
        $(this).attr("href", $(this).attr("href").replace("performance", "plan"))
        $(this).attr("href", $(this).attr("href").replace("forecast", "plan"))
        $(this).attr("href", $(this).attr("href").replace("compare_to_plan", "plan"))
      else if new_mode == "performance"
        $(this).attr("href", $(this).attr("href").replace("plan", "performance"))
        $(this).attr("href", $(this).attr("href").replace("forecast", "performance"))
        $(this).attr("href", $(this).attr("href").replace("compare_to_plan", "performance"))
      else if new_mode == "forecast"
        $(this).attr("href", $(this).attr("href").replace("plan", "forecast"))
        $(this).attr("href", $(this).attr("href").replace("performance", "forecast"))
        $(this).attr("href", $(this).attr("href").replace("compare_to_plan", "forecast"))
      else if new_mode == "compare_to_plan"
        $(this).attr("href", $(this).attr("href").replace("performance", "compare_to_plan"))
        $(this).attr("href", $(this).attr("href").replace("plan", "compare_to_plan"))
        $(this).attr("href", $(this).attr("href").replace("forecast", "compare_to_plan"))

    $(this).parents(".js-change-mode").find("li a").removeClass("active")
    $(this).addClass("active")

  # Change mode callback
  $(".js-change-mode").on "ajax:success", "li a", (e, data) ->
    $(".js-analysis").html(data.html)
    init_main_chart()
    init_tree_table()

  # Sticky nav
  if $(".secondaryNav").length > 0
    navPos = $(".fixedNav-trigger").offset().top
    $(window).scroll ->
      fixMenu = $(this).scrollTop() >= navPos - 1
      if fixMenu
        $('body').addClass "fixed-nav"
      else
        $('body').removeClass "fixed-nav"

  # Init treetable
  init_tree_table = ->
    $("#preformanceTable").treetable expandable: true
  init_tree_table()

  # Populate chart
  populate_chart = ->
    window.analysis_chart.data.datasets = []
    $(".js-select-for-chart").each ->
      return true unless $(this).is(":checked")
      color = $(this).parents("tr").find(".rowSelect-button").css("background-color")
      window.analysis_chart.data.datasets.push({
        label: $(this).parents(".firstCell").find(".rowTitle").text(),
        data: ($(this).parents("tr").find(".js-month-data").map -> $(this).text()).toArray(),
        fill: false,
        borderColor: color,
        backgroundColor: color,
        pointBorderColor: color,
        pointBackgroundColor: color,
        pointBorderWidth: 1
      })
    window.analysis_chart.update()

  # Select or unselect row for chart
  $(".js-analysis").on "change", ".js-select-for-chart", ->

    if $(this).is(":checked")
      $(".js-tags").append($(".js-tag-prototype").html())
      $(".js-tag:last").attr("data-level", $(this).parents("tr").data("level"))
      $(".js-tag:last").attr("data-identifier", $(this).parents("tr").data("identifier"))
      $(".js-tag:last .js-tag-name").text($(this).parents("tr").find(".rowTitle").text())

      color_pool = $("tr[data-color]").map ->
        parseInt($(this).attr("data-color"))

      color_pool = color_pool.toArray().sort()
      selected_color
      for color, index in color_pool
        if color != index
          selected_color = index
          break

      if selected_color == undefined
        selected_color = color_pool.length

      $(this).parents("tr").addClass("tag--color" + selected_color).attr("data-color", selected_color)
      $(".js-tag:last").attr("data-color", selected_color)
      $(".js-tag:last").css("background-color", $(this).parents("tr").find(".rowSelect-button").css("background-color"))
    else
      $(this).parents("tr").removeClass("tag--color" + $(this).parents("tr").data("color")).removeAttr("data-color")
      $(".js-tag[data-level=" + $(this).parents("tr").data("level") + "][data-identifier=" + $(this).parents("tr").data("identifier") + "]").remove()

    populate_chart()

  # Open presets modal
  $(".js-presets").on "click", ".js-save-preset", ->
    $(".modal-bg").fadeIn(200)
    $(".modal").fadeIn(200)

    # Build JSON data
    result = $(".js-tag:not(:first)").map ->
      result = {level: $(this).data("level"), identifier: $(this).data("identifier"), color: $(this).data("color")}

    $(".js-preset-data").val(JSON.stringify(result.toArray()))

    $(".modal input[type=text]:first").focus()
    return false

  # Cancel presets modal
  $(".modal").on "click", ".js-modal-cancel", ->
    $(".modal-bg").fadeOut(200)
    $(".modal").fadeOut(200)
    return false

  # Save preset
  $(".modal").on "click", ".js-modal-submit", ->
    $(".js-modal-cancel").click()

  # Delete preset
  $(".js-presets").on "click", ".js-delete-preset", ->
    $(this).parent().remove()

  # Save preset callback
  $(".modal").on "ajax:success", "form", (e, data) ->
    $(".js-preset-name").val("")
    $(".js-save-preset").parent().before(data.html)
    $(".js-select-preset").each ->
      $(this).parent().removeClass("active")
    $(".js-select-preset:last").parent().addClass("active")

  # Clear all tags
  $(".primaryContent").on "click", ".js-clear-presets", ->
    $(".js-tag-remove:not(:first)").click()

  # Select preset
  $(".js-presets").on "click", ".js-select-preset", ->
    return false if $(this).parent().hasClass("active")

    $(".js-select-for-chart:checked").click()
    for data in $(this).data("preset")
      $("tr[data-level=" + data["level"] + "][data-identifier=" + data["identifier"] + "]").find(".js-select-for-chart").click()

    $(".js-select-preset").each ->
      $(this).parent().removeClass("active")
    $(this).parents("li").addClass("active")
    return false

  # Remove tag from preset
  $(".js-presets").on "click", ".js-tag-remove", ->
    elem = $("tr[data-level=" + $(this).parents(".js-tag").data("level") + "][data-identifier=" + $(this).parents(".js-tag").data("identifier") + "]")
    elem.find(".js-select-for-chart").prop("checked", false)
    elem.removeClass("tag--color" + elem.data("color")).removeAttr("data-color")

    $(this).parents(".js-tag").remove()
    populate_chart()


  # Inits main chart
  init_main_chart = ->
    config =
      type: 'line'
      data:
        labels: ($(".js-chart-month").map -> $(this).val()).toArray(),
      options:
        animation: false
        responsive: true
        legend:
          position: 'bottom'
          display: false
        hover: mode: 'label'
        scales:
          xAxes: [{
            display: true
            scaleLabel:
              display: false
              labelString: 'Month'
            gridLines: display: true
          }]
          yAxes: [{
            ticks: maxTicksLimit: 4
            display: true
            scaleLabel:
              display: false
              labelString: 'Value'
            gridLines:
              display: false
              tickMarkLength: 49
          }]


    # Draw chart
    ctx = document.getElementById('canvas').getContext('2d')
    window.analysis_chart = new Chart(ctx, config)

    populate_chart()
  init_main_chart()


  # Inits doughnut charts
  init_doughnuts = ->
    config_sales =
      type: 'doughnut'
      data:
        datasets: [{
          data: ($("tr[data-tt-parent-id=1]").find(".js-sum").map -> $(this).text().trim()).toArray(),
          backgroundColor: ($("tr[data-tt-parent-id=1]").find(".js-sum").map -> "rgba(23,23,44, 0.7)").toArray()
        }]
        labels: ($("tr[data-tt-parent-id=1]").find(".rowTitle").map -> $(this).text().trim()).toArray()
      options:
        responsive: true
        legend:
          position: 'top'
          display: false
        title: display: false
        animation:
          animateScale: true
          animateRotate: true

    # Sales doughnut chart
    ctx = document.getElementById('js-sales-doughnut').getContext('2d')
    new Chart(ctx, config_sales)

    # Costs of sales doughnut chart
    ctx = document.getElementById('js-costs-of-sales-doughnut').getContext('2d')
    config_costs_of_sales = $.extend(true, {}, config_sales)
    config_costs_of_sales.data.labels = ($("tr[data-tt-parent-id=2]").find(".rowTitle").map -> $(this).text().trim()).toArray()
    config_costs_of_sales.data.datasets = [{
      data: ($("tr[data-tt-parent-id=2]").find(".js-sum").map -> $(this).text().trim()).toArray(),
      backgroundColor: ($("tr[data-tt-parent-id=2]").find(".js-sum").map -> "rgba(23,23,44, 0.7)").toArray()
    }]
    new Chart(ctx, config_costs_of_sales)

    # Costs doughnut chart
    ctx = document.getElementById('js-costs-doughnut').getContext('2d')
    config_costs = $.extend(true, {}, config_sales)
    config_costs.data.labels = ($("tr[data-tt-parent-id=4]").find(".rowTitle").map -> $(this).text().trim()).toArray()
    config_costs.data.datasets = [{
      data: ($("tr[data-tt-parent-id=4]").find(".js-sum").map -> $(this).text().trim()).toArray(),
      backgroundColor: ($("tr[data-tt-parent-id=4]").find(".js-sum").map -> "rgba(23,23,44, 0.7)").toArray()
    }]
    new Chart(ctx, config_costs)

    # Investments doughnut chart
    ctx = document.getElementById('js-investments-doughnut').getContext('2d')
    config_investments = $.extend(true, {}, config_sales)
    config_investments.data.labels = ($("tr[data-tt-parent-id=6]").find(".rowTitle").map -> $(this).text().trim()).toArray()
    config_investments.data.datasets = [{
      data: ($("tr[data-tt-parent-id=6]").find(".js-sum").map -> $(this).text().trim()).toArray(),
      backgroundColor: ($("tr[data-tt-parent-id=6]").find(".js-sum").map -> "rgba(23,23,44, 0.7)").toArray()
    }]
    new Chart(ctx, config_investments)
  init_doughnuts()
