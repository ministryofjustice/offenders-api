class Import
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :file, presence: true

  attr_accessor :file

  def initialize(file = nil)
    @file = file
  end

  def save
    # TODO
  end
end
