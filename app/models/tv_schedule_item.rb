class TvScheduleItem < ActiveRecord::Base
  validates_presence_of :starts_at, :description

  class << self
    def current_or_last_day
      where("date_trunc('day', starts_at) <= ?", Date.current)
        .maximum("date_trunc('day', starts_at)").try :to_date
    end

    def for_day(day)
      where("date_trunc('day', starts_at) = ?", day.to_date).order(:starts_at)
    end

    def import(file)
      transaction do
        spreadsheet = open_spreadsheet(file)
        total_imported = 0
        (1..spreadsheet.last_row).each do |line|
          date = spreadsheet.cell(line, 'A')
          time = spreadsheet.cell(line, 'B')
          if spreadsheet.celltype(line, 'A') == :date &&
             spreadsheet.celltype(line, 'B') == :time &&
             spreadsheet.celltype(line, 'C') == :string
            starts_at = (date + time.to_i.seconds if date)
            description = spreadsheet.cell(line, 'C').to_s.strip
            item = where(starts_at: starts_at).first_or_initialize(description: description)
            total_imported += 1 if item.save
          end
        end
        total_imported
      end
    end

    private

    def open_spreadsheet(file)
      require 'roo'
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      end
    end
  end
end
