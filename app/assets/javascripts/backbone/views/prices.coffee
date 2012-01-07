window.PricesView = SelectablesView.extend
    tagName: "table"
    className: "grid prices selectable"

    initElement: (options) ->
        new PriceView
          model:options.model
          collection: options.collection


