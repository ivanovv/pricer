window.PriceView = SelectableView.extend
    className: "price"
    template : _.template $("#price-template").html()

    initialize: ->
      SelectableView.prototype.initialize.apply(@, arguments)
      @model.bind "change", SelectableView.prototype.render, @