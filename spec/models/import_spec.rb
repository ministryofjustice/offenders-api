require 'rails_helper'

RSpec.describe Import, type: :model do
  it { should validate_presence_of(:file) }

  describe '#save' do

  end
end
