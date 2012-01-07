window.SelectablesView = Backbone.View.extend
    tagName: "table"
    className: "grid selectable"

    initialize: ->
        _.bindAll(@, "render", "addOne")
        @collection.bind('reset', @render)

    render: ->
        collection = @collection;
        collection.each((element) ->
            view = @initElement {model:element, collection:collection}
            $(@el).append(view.render().el)
        , @)
        @

    addOne: (element) ->
        view = @initElement {model: element, collection: @collection}
        $(@el).append view.render().el

