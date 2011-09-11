// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var fluid = {
    Ajax : function() {
        $("#loading").hide();
        $(".iframe-content").hide();

        $(".toggle-iframe").bind("click", function(e) {
            var $div = $(this).parent().parent().find(".iframe-content");
            if ($(this).is(".hidden-content")) {
                var existing_iframe = $div.find("iframe");
                if (existing_iframe.length == 0) {
                    $("#loading").show();
                    $('<iframe />', {
                        'class':   'external-search'
                    })
                    .attr('src', $div.data("url"))
                    .appendTo($div);
                }
                $div.slideDown();
            }
            else {
                $div.slideUp();
            }
            if ($(this).hasClass('hidden-content')) {
                $(this).removeClass('hidden-content').addClass('visible-content');
            }
            else {
                $(this).removeClass('visible-content').addClass('hidden-content');
            }
            e.preventDefault();
        });
    }
};

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

$(function() {
    $('#items_search').submit(function () {
        $.get(this.action, $(this).serialize(), null, 'script');
        return false;
    });

    $(".item").live("click", function() {
        $("#link_item_id").val($(this).attr('id').replace("item_", ""));
    });

    $(".colorbox").colorbox({width:"80%", height:"80%", iframe:true});

    buildGraph();
    fluid.Ajax();

    window.Pricer = Backbone.Router.extend({
        routes: {
                '' : 'home'
            },
        home: function(){
        }
    });
    window.App = new Pricer();
    Backbone.history.start({ pushState: true });

    companies = new Companies();
    companies.fetch();
    prices = new Prices();
    prices.find("2400s");
    items = new Items();
    items.find("2400s");

    /*priceView = new PriceListView({collection: prices});
    $('#new_prices').empty().append(priceView.render().el)*/
    
});

