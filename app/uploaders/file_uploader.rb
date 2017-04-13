class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def content_type_whitelist
    ['text/csv', 'text/comma-separated-values']
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  def md5
    @md5 ||= Digest::MD5.hexdigest model.send(mounted_as).read.to_s
  end
end
