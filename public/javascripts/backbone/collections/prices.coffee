window.Prices = Backbone.Collection.extend({
    model: Price,
    url: function() {
        if (this.company)
            return  "/pricer/companies/" + this.company.id + "/prices";
        else
            return  "/pricer/prices";
    },

    initialize: function(models, options) {
        if (options) {
            this.company = options.company;
        }
    },

    selected: function() {
        return this.select(function(model){
            return model.get('selected');
        });
    }
});