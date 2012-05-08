window.LinkerView = Backbone.View.extend
  tagName: "a"
  className: "btn btn-primary invisible"
  id: "link_btn"
  template: "<i class='icon-magnet icon-white'></i>  Связать!"
  events :
    'click' : 'link'

  initialize: (options) ->
    _.bindAll @, "render", "updateSelectionStatus"
    @prices = options.prices
    @items = options.items
    @prices.bind "change:selected", @updateSelectionStatus, @
    @items.bind "change:selected", @updateSelectionStatus, @

  render: ->
    $(@el).html(@template)
    @

  updateSelectionStatus: ->
    setTimeout ( =>
      $(@el).toggleClass("invisible", !(@prices.selected().size() > 0 && @items.selected().size() > 0))
    ), 100

  link : ->
    selected_prices = @prices.selected()
    selected_items = @items.selected()
    if selected_prices.size() == 0
      alert "No prices selected!"
      return false

    if selected_items.size() == 0 || selected_items.size() > 1
      alert "Select one item (only)!"
      return false

    selected_items.first().link_items(selected_prices, true, 10)
    selected_prices.each (price) ->
      price.set( selected : false )

    return false
