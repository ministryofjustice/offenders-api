require 'rails_helper'

RSpec.describe Upload, type: :model do
  it { should validate_presence_of(:md5) }
  it { should validate_uniqueness_of(:md5) }
end
