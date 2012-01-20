window.SelectablesView = Backbone.View.extend
    tagName: "table"
    className: "grid selectable"

    initialize: ->
        _.bindAll(@, "render", "addOne")
        @collection.bind('reset', @render)

    render: ->
        $(@el).empty()
        collection = @collection;
        collection.each((element) ->
            @addOne element
        , @)
        @

    addOne: (element) ->
        view = @initElement {model: element, collection: @collection}
        $(@el).append(view.render().el)

