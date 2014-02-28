class LegacyShow < Event
  include Playlistable

  def search_result_type
    "Show"
  end
end
