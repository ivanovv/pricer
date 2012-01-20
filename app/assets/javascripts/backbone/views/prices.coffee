window.PricesView = SelectablesView.extend
    tagName: "table"
    className: "grid prices selectable"

    initElement: (options) ->
        new PriceView
          model: options.model
          collection: options.collection

    render: ->
        SelectablesView.prototype.render.apply(@, arguments)
        $("#prices_count").text(@collection.length)
        @


