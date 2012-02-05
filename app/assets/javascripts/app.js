// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function buildGraph() {

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
            $('<div id="tooltip">' + contents + '</div>').css({
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
                        price = item.datapoint[1].toFixed(2);

                    showTooltip(item.pageX, item.pageY - 40, price + " р.");
                }
            } else {
                $("#tooltip").remove();
                previousPoint = null;
            }
        });
    }
}

Pricer.Selector = {};

Pricer.Selector.mouseup = function() {
    var userSelection;
    if (window.getSelection) {
        userSelection = window.getSelection();
    }
    else if (document.selection) {
        userSelection = document.selection.createRange();
    }

    var selectedText = userSelection;
    if (userSelection.text) selectedText = userSelection.text;

    if (selectedText != '') {
        $("#q").each(function() {
            $(this).val(selectedText);
        });
    }
}

$(function() {
    $('#items_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, 'script');
        return false;
    });

    $(".colorbox").colorbox({width:"80%", height:"80%", iframe:true});

    buildGraph();
    $(document).bind("mouseup", Pricer.Selector.mouseup);
});

