window.Item = SelectableModel.extend
    link_items: (prices, human, score) ->
        item_id = @id
        self = @
        deferreds = []
        prices.each (price) ->
            link = new Link item_id: item_id, price_id: price.id, human: human, score: score
            deferred = link.save {},
                success: ->
                    price.set { linked: "Да" }
                    self.set { prices_count: (self.get 'prices_count') + 1 }
            deferreds.push deferred

        $.when.apply null, deferreds