class EnableSoundex < ActiveRecord::Migration
  def up
    enable_extension 'fuzzystrmatch'
  end

  def down
    disable_extension 'fuzzystrmatch'
  end
end
