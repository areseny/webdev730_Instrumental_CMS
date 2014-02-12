jQuery(function($) {

  $("#artists-table").dataTable({
    "bProcessing": true,
    "bAutoWidth": false,
    "sAjaxSource": "/ueber/artists/datatable.json",
    "aoColumns": [
      { "iDataSort":  4, "sWidth": "200px" },
      { "sWidth": "120px" },
      { "sWidth": "120px" },
      { "bSortable": false },
      { "bVisible": false }
    ]
  });

});
