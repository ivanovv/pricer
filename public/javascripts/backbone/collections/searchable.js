window.Searchable = Backbone.Collection.extend({
    find: function(search_term){
        this.fetch({data: {q: search_term}});
    }
});
