window.ItemView = SelectableView.extend
    className: "item"
    template : _.template $("#item-template").html()

    initialize: ->
      SelectableView.prototype.initialize.apply(@, arguments)
      @model.bind "change:prices_count", SelectableView.prototype.render, @
