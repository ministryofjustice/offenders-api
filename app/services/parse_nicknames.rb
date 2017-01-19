module ParseNicknames
  module_function

  def call(data)
    require 'csv'

    Nickname.delete_all

    CSV.parse(data) do |row|
      diminutive = row[0]
      result = Nickname.create(name: diminutive.upcase)
      result.update(nickname_id: result.id)
      row[1..-1].each do |nickname|
        Nickname.create(name: nickname.upcase, nickname_id: result.id)
      end
    end
  end
end
