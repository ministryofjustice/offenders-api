class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def content_type_whitelist
    ['application/text', 'text/csv', 'application/vnd.ms-excel']
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
