class Alias
  include Mongoid::Document

  field :name, type: String

  embedded_in :prisoner
end
