window.ItemsView = SelectablesView.extend({
    tagName: "table",
    className: "grid items selectable",
    template: _.template($("#items-template").html()),

   initElement: function(options){
        return new ItemView({model:options.model, collection: options.collection});
    }
});