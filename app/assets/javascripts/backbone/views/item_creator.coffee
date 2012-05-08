window.ItemCreatorView = Backbone.View.extend
  tagName: "a"
  className: "btn btn-primary invisible"
  id: "link_btn"
  template: "<i class='icon-plus icon-white'></i> Создать запись в справочнике"
  events :
    'click' : 'new_item'

  initialize: (options) ->
    _.bindAll @, "render", "updateSelectionStatus"
    @prices = options.prices
    @prices.bind "change:selected", @updateSelectionStatus, @

  render: ->
    $(@el).html(@template)
    @

  updateSelectionStatus: ->
    setTimeout ( =>
      $(@el).toggleClass("invisible", !(@prices.selected().size() > 1))
    ), 100

  new_item : ->
    $("#new_item").modal()
    $('#new_item .modal-body').load("/items/new", "", () ->
      $("#new_item .modal-body .actions").hide()
    );

    return false
