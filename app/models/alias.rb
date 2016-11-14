class Alias < ActiveRecord::Base
  include Swagger::Blocks

  # rubocop:disable Metrics/BlockLength
  swagger_schema :Alias do
    key :required, [:id, :given_name, :surname, :date_of_birth, :gender]
    property :id do
      key :type, :integer
      key :format, :int32
    end
    property :title do
      key :type, :string
    end
    property :given_name do
      key :type, :string
    end
    property :middle_names do
      key :type, :string
    end
    property :surname do
      key :type, :string
    end
    property :suffix do
      key :type, :string
    end
    property :date_of_birth do
      key :type, :string
      key :format, :date
    end
    property :gender do
      key :type, :string
    end
    property :pnc_number do
      key :type, :string
    end
    property :cro_number do
      key :type, :string
    end
  end

  has_paper_trail

  belongs_to :prisoner

  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
end
