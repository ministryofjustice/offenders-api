class Prisoner < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Prisoner do
    key :required, [:id, :noms_id, :given_name, :surname, :date_of_birth, :gender]
    property :id do
      key :type, :string
      key :format, :uuid
    end
    property :noms_id do
      key :type, :string
    end
    property :given_name do
      key :type, :string
    end
    property :surname do
      key :type, :string
    end
    property :date_of_birth do
      key :type, :string
      key :format, :date
    end
    property :gender do
      key :type, :string
    end
  end

  has_paper_trail

  has_many :aliases, dependent: :destroy

  validates :noms_id, presence: true
  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true

  scope :updated_after, -> (time) { where("updated_at > ?", time) }
end
