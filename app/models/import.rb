class Import < ActiveRecord::Base
  mount_uploader :offenders_file, FileUploader

  validates :offenders_file, presence: true
  validate :offenders_file_uniqueness

  after_create :create_upload

  private

  def create_upload
    Upload.create(md5: offenders_file.md5)
  end

  def offenders_file_uniqueness
    return unless Upload.where(md5: offenders_file.md5).any?
    errors[:base] << 'This file has already been uploaded'
  end
end
