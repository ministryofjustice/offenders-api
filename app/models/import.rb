class Import < ActiveRecord::Base
  mount_uploader :prisoners_file, FileUploader
  mount_uploader :aliases_file, FileUploader

  validates :prisoners_file, presence: true
  validates :aliases_file, presence: true
  validate :prisoners_file_uniqueness
  validate :aliases_file_uniqueness

  after_create :create_uploads

  private

  def create_uploads
    Upload.create(md5: prisoners_file.md5)
    Upload.create(md5: aliases_file.md5)
  end

  def prisoners_file_uniqueness
    if Upload.where(md5: prisoners_file.md5).any?
      errors[:base] << 'Prisoners file has already been uploaded'
    end
  end

  def aliases_file_uniqueness
    if Upload.where(md5: aliases_file.md5).any?
      errors[:base] << 'Aliases file has already been uploaded'
    end
  end
end
