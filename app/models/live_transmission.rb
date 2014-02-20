class LiveTransmission < ActiveRecord::Base
  belongs_to :artist

  def twitter_text
    "Ao vivo no Instrumental SESC Brasil: #{artist.name}"
  end

  def email_subject
    "Transmissão ao vivo no Instrumental SESC Brasil: #{artist.name}"
  end

  def email_body
    "Não deixe de conferir a transmissão ao vivo do show de #{artist.name} no Instrumental SESC Brasil\n\nhttp://instrumentalsescbrasil.org.br/aovivo/#{id}"
  end

  def self.current
    today = Date.current
    now = Time.current
    if transmission = where("date = ?", today).first
      settings = LiveTransmissionSettings.current
      start = today.to_time + settings.starts_at.hour.hours + settings.starts_at.min.minutes
      finish = today.to_time + settings.ends_at.hour.hours + settings.ends_at.min.minutes
      if now > start && now < finish
        transmission
      end
    end
  end

  def self.next
    where("date >= ?", Date.current).limit(4)
  end

  def self.live_status
    Rails.cache.fetch("live-status-json", :expires_in => 30.seconds) do
      if transmission = LiveTransmission.current
        { artist: transmission.artist.name, id: transmission.id }
      else
        {}
      end
    end
  end

end
