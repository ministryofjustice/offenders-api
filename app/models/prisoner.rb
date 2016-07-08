class Prisoner < ActiveRecord::Base
  has_many :aliases, dependent: :destroy

  validates :noms_id, presence: true
  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true

  class << self
    def search(term)
      term.strip! rescue nil
      basic_search(searchable_columns.inject({}) { |h, c| h[c] = term; h }, false)
    end

    def searchable_columns
      [
        :given_name,
        :middle_names,
        :surname
      ]
    end
  end
end
