class ThumbnailUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog
  process convert: 'jpg'
  resize_to_fill 200, 200

  def store_dir
    "artistas/#{model.slug}"
  end

  def filename
    "thumbnail-#{md5}.jpg" if original_filename
  end

  def default_url
    ActionController::Base.helpers.asset_path("no-thumbnail.jpg")
  end

  private

  def md5
    @md5 ||= ::Digest::MD5.file(current_path).hexdigest
  end

end
