window.Prices = window.Searchable.extend
    model: Price
    url: ->
        if @company
            "/companies/#{@company.id}/prices"
        else
            "/prices"

    initialize: (models, options) ->
        if options
            @company = options.company