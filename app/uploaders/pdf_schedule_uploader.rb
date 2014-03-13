class PdfScheduleUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "programacao"
  end

  def filename
    if original_filename
      if date = model.try(:available_date)
        I18n.l(date, format: :date_slug) + ".pdf"
      end
    end
  end

end
