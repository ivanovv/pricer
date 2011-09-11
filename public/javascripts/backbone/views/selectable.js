window.SelectableView = Backbone.View.extend({
    tagName: "tr",

    events : {
                'click' : 'select'
            },

    initialize: function() {
        _.bindAll(this, "render", "select", "setSelected");
        this.model.bind("change:selected", this.setSelected);
    },

    render: function() {
        $(this.el).html(this.template(this.model.toJSON()));
        this.setSelected();
        return this;
    },

    select: function() {
        this.model.set({selected : !this.model.get("selected")});
    },

    setSelected: function() {
        var selected = this.model.get("selected");
        $(this.el).toggleClass('ui-selected', selected);
        this.$("*").toggleClass('ui-selected', selected);
    }
});