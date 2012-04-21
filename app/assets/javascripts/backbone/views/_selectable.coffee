window.SelectableView = Backbone.View.extend
    tagName: "tr"
    events :
      'click' : 'select'

    initialize: ->
        _.bindAll @, "render", "select", "updateSelectedStatus"
        @model.bind "change:selected", @updateSelectedStatus


    render: ->
        $(@el).html(@template(@model.toJSON()))
        @updateSelectedStatus()
        @

    select: ->
        @model.set {selected : !@model.get "selected"}

    updateSelectedStatus: ->
        selected = @model.get "selected"
        $(@el).toggleClass 'ui-selected', selected
        @$("*").toggleClass 'ui-selected', selected