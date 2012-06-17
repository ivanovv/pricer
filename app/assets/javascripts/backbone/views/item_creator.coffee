window.ItemCreatorView = Backbone.View.extend
  tagName: "a"
  className: "btn btn-primary invisible"
  id: "link_btn"
  template: "<i class='icon-plus icon-white'></i> Создать запись в справочнике"
  events :
    'click' : 'new_item'

  initialize: (options) ->
    _.bindAll @, "render", "updateSelectionStatus", "new_item"
    @prices = options.prices
    @prices.bind "change:selected", @updateSelectionStatus, @

  render: ->
    $(@el).html(@template)
    @

  updateSelectionStatus: ->
    setTimeout ( =>
      $(@el).toggleClass("invisible", !(@prices.selected().size() > 1))
    ), 100

  new_item : ->
    $("#new_item").modal()
    $('#new_item .modal-body').load("/items/new", "", () =>
      $modalBody = $("#new_item .modal-body")
      $(".actions", $modalBody).hide()
      descriptions = _(@prices.selected().map((p) -> p.attributes["description"]))
      final_description = []
      all_words = descriptions.chain().map( (desc) -> desc.split(" ")).flatten().uniq().value().join(" ")

      $("#item_original_description", $modalBody).val(all_words)
      $("#item_description", $modalBody).val(all_words)
    );

    return false
