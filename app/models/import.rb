class Import < ActiveRecord::Base
  mount_uploader :offenders_file, FileUploader
  mount_uploader :identities_file, FileUploader

  validates :offenders_file, presence: true
  validates :identities_file, presence: true
  validate :offenders_file_uniqueness
  validate :identities_file_uniqueness

  after_create :create_uploads

  private

  def create_uploads
    Upload.create(md5: offenders_file.md5)
    Upload.create(md5: identities_file.md5)
  end

  def offenders_file_uniqueness
    return unless Upload.where(md5: offenders_file.md5).any?
    errors[:base] << 'Offenders file has already been uploaded'
  end

  def identities_file_uniqueness
    return unless Upload.where(md5: identities_file.md5).any?
    errors[:base] << 'Identities file has already been uploaded'
  end
end
