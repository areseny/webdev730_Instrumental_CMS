jQuery ($) ->

  $(".instruments-tokenfield").tokenfield
    typeahead:
      name: 'instruments'
      prefetch: '/ueber/instruments.json'
      local: ["guitarra", "violao", "gaita"]
