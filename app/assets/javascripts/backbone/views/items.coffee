window.ItemsView = SelectablesView.extend
  tagName: "table"
  className: "grid items selectable"

  initElement: (options) ->
    new ItemView
      model:options.model
      collection: options.collection