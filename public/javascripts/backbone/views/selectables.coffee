window.SelectablesView = Backbone.View.extend({
    tagName: "table",
    className: "grid prices selectable",
    template: _.template($("#prices-template").html()),


    initialize: function() {
        _.bindAll(this, "render", "addOne");
        this.collection.bind('reset', this.render);
    },

    render: function() {
        var $elements;
        var collection = this.collection;

        $(this.el).html(this.template({}));
        $elements = this.$("tbody");
        collection.each(function(element) {
            var view = this.initElement({model:element, collection:collection});
            $elements.append(view.render().el);
        }, this);
        return this;
    },

    addOne: function(element){
        var view = this.initElement({model:element, collection: this.collection});
        this.$("tbody").append(view.render().el);
    }
});

