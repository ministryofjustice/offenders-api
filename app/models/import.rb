class Import < ActiveRecord::Base
  mount_uploader :file, FileUploader

  validates :file, presence: true
  validates :md5, presence: true, uniqueness: true

  before_validation :generate_md5
  after_create :remove_previous

  private

  def generate_md5
    if file.present? && file_changed?
      self.md5 = file.md5
    end
  end

  def remove_previous
    Import.where('id != ?', self.id).destroy_all
  end
end
