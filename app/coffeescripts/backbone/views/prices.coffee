window.PricesView = SelectablesView.extend
    tagName: "table"
    className: "grid prices selectable"
    template: _.template $("#prices-template").html()

    initElement: (options) ->
        new PriceView
          model:options.model
          collection: options.collection


