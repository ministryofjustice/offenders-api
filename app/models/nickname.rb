class Nickname < ActiveRecord::Base
  belongs_to :nickname

  scope :for, -> (name) { where(['nickname_id IN (SELECT nickname_id FROM nicknames WHERE name = ?)', name.upcase]) }
end
