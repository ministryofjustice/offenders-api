require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES) }

  describe 'roles' do
    let(:user) { create(:user, email: 'user@example.com', role: role) }

    describe '#admin?' do
      let(:role) { 'admin' }

      it 'returns true when admin' do
        expect(user.admin?).to be true
      end

      it 'returns false when not admin' do
        user.update_attribute(:role, 'staff')
        expect(user.admin?).to be false
      end
    end

    describe '#staff?' do
      let(:role) { 'staff' }

      it 'returns true when staff' do
        expect(user.staff?).to be true
      end

      it 'returns false when not staff' do
        user.update_attribute(:role, 'admin')
        expect(user.staff?).to be false
      end
    end
  end
end
