jQuery(function($) {

  $(".show-select").typeahead([{
    name: 'typeahead-shows-prefetch',
    prefetch: {
      url: '/ueber/shows/typeahead.json',
      ttl_ms: 60000
    },
    valueKey: 'name',
    highlight: true
  }]).on("typeahead:selected typeahead:autocompleted", function(e, datum) {
    $($(this).data("targetId")).val(datum.id);
    $($(this).data("targetDescription")).val(datum.artist_description);
  });

  $(".show-select").change(function() {
    $($(this).data("targetId")).val("");
  });

});
