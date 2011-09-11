window.Companies = Backbone.Collection.extend({
    model: Company,
    url: "/pricer/companies"
});