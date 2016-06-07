# Stubbed, temporary Prisoner model

class Prisoner
  def self.all
    [first]
  end

  def self.first
    find(1)
  end

  def self.find(id)
    { id: SecureRandom.uuid, name: 'John Smith' }
  end

  def aliases
    [{ name: 'Shanker' }]
  end
end
