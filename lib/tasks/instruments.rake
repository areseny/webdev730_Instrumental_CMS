require 'csv'

namespace :instruments do
  task :fix => :environment do
    logger.info '------START instruments:fix------'
    logger.info '------Remove All Instruments------'
    Instrument.all.each do |instrument|
      instrument.destroy!
    end

    logger.info '------Import Instruments.csv------'
    CSV.foreach('Instruments.csv', :headers => false) do |row|
      Instrument.create!(name: row[0].strip)
    end

    logger.info '------Import Artists_Instruments.csv------'
    CSV.foreach('Artists_Instruments.csv', :headers => false) do |row|
      artist = Artist.find_by_slug(row[0].strip)
      if artist.nil?
        logger.info "No artist found with the slug #{row[0].strip}"
        next
      else
        instrument_names = []
        instrument_names = row[1].split(',') unless row[1].nil?

        instrument_names.each do |instrument_name|
          instrument = Instrument.find_by_name(instrument_name.strip)
          if instrument.nil?
            logger.info "No instrument found with the name #{instrument_name.strip}"
            next
          end

          artist.instruments << instrument
        end
      end
      artist.save!
    end
    logger.info '------END instruments:fix------'
  end
end
