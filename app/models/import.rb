class Import < ActiveRecord::Base
  mount_uploader :file, FileUploader

  validates :file, presence: true
  validates :md5, presence: true, uniqueness: true

  before_validation :set_md5

  private

  def set_md5
    if file.present? && file_changed?
      self.md5 = file.md5
    end
  end
end
