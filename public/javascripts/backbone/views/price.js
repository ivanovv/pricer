window.PriceView = Backbone.View.extend({
    tagName: "tr",
    className: "price",
    template : _.template($("#price-template").html()),

    events : {
                'click' : 'select'
            },

    initialize: function() {
        _.bindAll(this, "render", "select");
        this.model.bind("change", this.render);
    },

    render: function() {
        $(this.el).html(this.template(this.model.toJSON()));
        var selected = this.model.get("selected");
        $(this.el).toggleClass('ui-selected', selected);
        this.$("*").toggleClass('ui-selected', selected);
        return this;
    },

    select: function() {
        this.model.set({selected : !this.model.get("selected")});
    }
});

window.PriceListView = Backbone.View.extend({
    tagName: "table",
    className: "grid prices selectable",
    template: _.template($("#prices-template").html()),


    initialize: function() {
        _.bindAll(this, "render");
        this.collection.bind('reset', this.render);
    },

    render: function() {
        var $prices;
        var collection = this.collection;

        $(this.el).html(this.template({}));
        $prices = this.$("tbody");
        collection.each(function(price) {
            var view = new PriceView({model:price, collection: collection});
            $prices.append(view.render().el);
        });
        return this;
    }
});