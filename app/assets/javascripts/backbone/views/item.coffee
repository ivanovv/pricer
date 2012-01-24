window.ItemView = SelectableView.extend
    className: "item"
    template : _.template(if $("#item-template").length > 0 then $("#item-template").html() else "")

    initialize: ->
      SelectableView.prototype.initialize.apply(@, arguments)
      @model.bind "change:prices_count", SelectableView.prototype.render, @
