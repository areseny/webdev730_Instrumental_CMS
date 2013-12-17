jQuery ->
  $(document).on "click", ".tab", (e) ->
    panel = $($(this).attr("href"))
    console.info panel
    $(".tab").removeClass("tab-selected")
    $(this).addClass("tab-selected")
    $(".schedule-tab").removeClass("schedule-tab-selected")
    $(this).closest(".schedule-tab").addClass("schedule-tab-selected")
    $(".tab-panel").removeClass("tab-panel-selected")
    $(panel).addClass("tab-panel-selected")
    false
