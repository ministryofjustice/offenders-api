class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def content_type_whitelist
    ['application/text', 'text/csv', 'application/vnd.ms-excel']
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  def md5
    @md5 ||= Digest::MD5.hexdigest model.send(mounted_as).read.to_s
  end
end
