window.PriceView = Backbone.View.extend({
    tagName: "tr",
    className: "price",
    template : _.template($("#price-template").html()),

    initialize: function() {
        _.bindAll(this, "render");
        this.model.bind("change", this.render);
    },

    render: function() {
        var renderedContent = this.template(this.model.toJSON());
        $(this.el).html(renderedContent);
        return this;
    }
});

window.PriceListView = Backbone.View.extend({
    tagName: "div",
    className: "prices",

    initialize: function() {
        _.bindAll(this, "render");
        this.collection.bind('reset', this.render);
        this.template = _.template($("#prices-template").html());
    },

    render: function() {
        var $prices;
        var collection = this.collection;

        $(this.el).html(this.template({}));
        $prices = this.$(".prices");
        collection.each(function(price) {
            var view = new LibraryAlbumView({model:album, collection: collection});
            $prices.append(view.render().el);
        });
        return this;
    }
});