class FeatureBannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
  process convert: 'jpg'
  resize_to_fit 900, 500

  def store_dir
    "features"
  end

  def filename
    "banner-#{md5}.jpg" if original_filename
  end

  def store_geometry
    if @file && model
      img = ::Magick::Image::read(@file.file).first
      model.banner_width = img.columns
      model.banner_height = img.rows
    end
  end
  process :store_geometry

  private

  def md5
    @md5 ||= ::Digest::MD5.file(current_path).hexdigest
  end

end
