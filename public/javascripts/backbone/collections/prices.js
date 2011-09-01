window.Prices = Backbone.Collection.extend({
    model: Price,
    url: function(){
       return  "/pricer/companies/" + this.company.id + "/prices";
    },

    initialize: function(models, options){
        this.company = options.company;
    }
    
});