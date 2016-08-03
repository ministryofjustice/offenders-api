class Upload < ActiveRecord::Base
  validates :md5, presence: true, uniqueness: true
end
