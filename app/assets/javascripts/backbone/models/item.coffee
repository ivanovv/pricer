window.Item = SelectableModel.extend
    link_items: (prices, human, score) ->
        item_id = @id
        prices.each (price) ->
            link = new Link {item_id:item_id, price_id:price.id, human:human, score:score}
            link.save()

