window.SelectablesView = Backbone.View.extend
    tagName: "table"
    className: "grid prices selectable"
    template: _.template $("#prices-template").html()

    initialize: ->
        _.bindAll(@, "render", "addOne")
        @collection.bind('reset', @render)

    render: ->
        collection = @collection;

        $(@el).html(@template({}));
        $elements = @$("tbody");
        collection.each((element) ->
            view = @initElement({model:element, collection:collection})
            $elements.append(view.render().el)
        , @)
        @

    addOne: (element) ->
        view = @initElement({model:element, collection: @collection})
        @$("tbody").append(view.render().el)