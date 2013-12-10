class GalleryUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
  process convert: 'jpg'

  def store_dir
    "artistas/#{model.artist.slug}"
  end

  def filename
    "gallery-#{md5}.jpg" if original_filename
  end

  def store_geometry
    if @file && model
      img = ::Magick::Image::read(@file.file).first
      model.width = img.columns
      model.height = img.rows
    end
  end
  process :store_geometry

  private

  def md5
    @md5 ||= ::Digest::MD5.file(current_path).hexdigest
  end

end
