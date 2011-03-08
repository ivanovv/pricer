// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
 $(function () {
     $('#items_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, 'script');
        return false;
        });

     $(".found_item").live("click", function() {
         $("#link_item_id").val($(this).attr('id').replace("item-", ""));
     });


     $(".colorbox").colorbox({width:"80%", height:"80%", iframe:true});

 });