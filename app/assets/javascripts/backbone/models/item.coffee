window.Item = SelectableModel.extend
    link_items: (prices, human, score) ->
        item_id = @id
        prices_count = @get 'prices_count'
        self = @
        prices.each (price) ->
          link = new Link {item_id: item_id, price_id: price.id, human: human, score: score}
          link.save {}, success: ->
            price.set { linked: "Да" }
            self.set { prices_count: prices_count + 1 }

