class Import < ActiveRecord::Base
  mount_uploader :file, FileUploader

  validates :file, presence: true
  validate :file_uniqueness

  after_create :create_upload

  private

  def create_upload
    Upload.create(md5: file.md5)
  end

  def file_uniqueness
    if Upload.where(md5: file.md5).any?
      errors[:base] << 'File has already been uploaded'
    end
  end
end
