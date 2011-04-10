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

     var $flot_placeholder = $("#flot_placeholder");
     if ($flot_placeholder.length == 1) {
        $.plot($flot_placeholder, $flot_placeholder.data("graph"), {
            series: {
                   lines: { show: true },
                   points: { show: true }
            },
            xaxis: {
                mode: "time",
                monthNames: ["янв", "фев", "март", "апр", "май", "июнь", "июль", "авг", "сен", "окт", "ноя", "дек"]
            },
            yaxis: {
                //ticks: 10,
                autoscaleMargin: 0.4

            },
             grid: {
                 hoverable: true
             }
        });
        function showTooltip(x, y, contents) {
            $('<div id="tooltip">' + contents + '</div>').css( {
                 position: 'absolute',
                 display: 'none',
                 top: y + 5,
                 left: x + 5,
                 border: '1px solid #fdd',
                 padding: '2px',
                 'background-color': '#fee',
                 opacity: 0.80
             }).appendTo("body").fadeIn(200);
        }
            
        var previousPoint = null;
        $("#flot_placeholder").bind("plothover", function (event, pos, item) {
            if (item) {
                if (previousPoint != item.datapoint) {
                    previousPoint = item.datapoint;

                    $("#tooltip").remove();
                    var x = item.datapoint[0].toFixed(2),
                        y = item.datapoint[1].toFixed(2);

                    showTooltip(item.pageX, item.pageY - 40, y + " р.");
                }
            } else {
                $("#tooltip").remove();
                previousPoint = null;
            }
        });
     }
 });

