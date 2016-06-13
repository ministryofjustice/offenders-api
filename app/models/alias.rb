class Alias
  include Mongoid::Document

  field :name, type: String

  belongs_to :prisoner
end
