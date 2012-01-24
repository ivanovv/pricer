window.PriceView = SelectableView.extend
    className: "price"
    template : _.template(if $("#price-template").length > 0 then  $("#price-template").html() else "")

    initialize: ->
      SelectableView.prototype.initialize.apply(@, arguments)
      @model.bind "change", SelectableView.prototype.render, @