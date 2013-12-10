class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
  process convert: 'jpg'
  resize_to_fit 900, 500

  def store_dir
    "artistas/#{model.slug}"
  end

  def filename
    "banner-#{md5}.jpg" if original_filename
  end

  def default_url
    ActionController::Base.helpers.asset_path("no-banner.jpg")
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
