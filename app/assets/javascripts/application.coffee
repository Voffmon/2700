# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap_dropdown
#= require chart.bundle.min
#= require jquery.treetable
#= require sortable
#= require_tree .

# Returns true if current controller and current action matches the provided parameters.
# Used for running scripts only on specific pages.
@page = (controller, action) ->
  $("body").attr("data-controller-name") == controller and
  $("body").attr("data-action-name")     == action


# Page transition: Leave page
#$(document).on 'turbolinks:request-start', ->
#  $('.primaryContent').removeClass("fadeIn").addClass('fadeOut').fadeOut(500)

# Page transition: Start rendering
#$(document).on 'turbolinks:before-render', ->
#  $(event.data.newBody).find(".primaryContent").hide()

# Page transition: Leave page
#$(document).on 'turbolinks:load', ->
#  $('.primaryContent').addClass('fadeIn').fadeIn(500)
