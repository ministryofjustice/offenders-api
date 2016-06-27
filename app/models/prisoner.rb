class Prisoner < ActiveRecord::Base
  has_many :aliases, dependent: :destroy
end
