$(document).on "turbolinks:load", ->

  return unless page("positions", "show")

  # Toggle position active state
  $(document).on "ajax:success", ".js-set-state", (e, data) ->
    $(this).parent().find(".js-active-state").text(data.active_state)

  # Switcher element for setting active / inactive state
  $(".js-switch-active-inactive").on "change", ->
    if $(this).is(":checked") then $(".js-set-active").click() else $(".js-set-inactive").click()

  # Toggle needs attention
  $(".js-needs-attention").on "change", ->
    $(".js-toggle-needs-attention").click()

  # Config for chart
  config =
    type: 'line'
    data:
      labels: ($(".js-chart-month").map -> $(this).val()).toArray(),
      datasets: [{
        label: "Plan",
        data: ($(".js-chart-plan").map -> $(this).val()).toArray(),
        backgroundColor: $(".tag--color0").css("background-color"),
        fill: false
      }, {
        label: "Forecast",
        data: ($(".js-chart-forecast").map -> $(this).val()).toArray(),
        backgroundColor: $(".tag--color1").css("background-color"),
        fill: false
      }, {
        label: "Performance"
        data: ($(".js-chart-performance").map -> $(this).val()).toArray(),
        backgroundColor: $(".tag--color2").css("background-color"),
        fill: false
      }],
    options:
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

  # Config for chart
  $.each config.data.datasets, (i, dataset) ->
    dataset.borderColor = dataset.backgroundColor
    dataset.backgroundColor = dataset.backgroundColor
    dataset.pointBorderColor = dataset.backgroundColor
    dataset.pointBackgroundColor = dataset.backgroundColor
    dataset.pointBorderWidth = 1

  # Draw chart
  ctx = document.getElementById('canvas').getContext('2d')
  new Chart(ctx, config)
