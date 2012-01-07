window.Searchable = Backbone.Collection.extend
    find: (search_term) ->
        @fetch data: {q: search_term}