window.Prices = Searchable.extend
    model: Price
    url: ->
        if @company
            "/pricer/companies/#{@company.id}/prices"
        else
            "/pricer/prices"
            
    initialize: (models, options) ->
        if options
            @company = options.company

    selected: ->
        @select (model) ->
            model.get 'selected'
            