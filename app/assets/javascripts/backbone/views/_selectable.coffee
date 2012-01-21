window.SelectableView = Backbone.View.extend
    tagName: "tr"
    events :
      'click' : 'select'

    initialize: ->
        _.bindAll @, "render", "select", "setSelected"
        @model.bind "change:selected", @setSelected


    render: ->
        $(@el).html(@template(@model.toJSON()))
        @setSelected()
        @

    select: ->
        @model.set {selected : !@model.get "selected"}

    setSelected: ->
        selected = @model.get "selected"
        $(@el).toggleClass 'ui-selected', selected
        @$("*").toggleClass 'ui-selected', selected