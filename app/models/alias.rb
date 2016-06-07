class Alias
  def self.all
    [first]
  end

  def self.first
    find(1)
  end

  def self.find(id)
    { name: 'Shanker' }
  end
end
