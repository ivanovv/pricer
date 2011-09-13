window.SearchRouter = Backbone.Router.extend
  routes:
    'search/:q' : 'search'
    ''          : 'home'
  home: ->
    companies = new Companies()
    companies.fetch()
    window.prices = new Prices()
    window.items = new Items()

  search: (q)->
    #home() if not window.items
    window.items.find q
    window.prices.find q
