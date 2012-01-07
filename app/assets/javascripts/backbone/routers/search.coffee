window.SearchRouter = Backbone.Router.extend
  routes:
    'search/:q' : 'search'
    ''          : 'init'
  init: ->
    companies = new Companies()
    companies.fetch()
    window.prices = new Prices()
    window.items = new Items()

  search: (q) ->
    @init() if typeof items == "undefined"
    window.items.find q
    window.prices.find q
