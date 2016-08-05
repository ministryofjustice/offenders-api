require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:role) }
  it { should validate_inclusion_of(:role).in_array(User::ROLES) }

  describe 'roles' do
    let(:user) do
      User.create(
        email: 'example@example.com',
        password: 'password',
        password_confirmation: 'password',
        role: role
      )
    end

    describe '#admin?' do
      let(:role) { 'admin' }

      it 'should return true when admin' do
        expect(user.admin?).to eq(true)
      end

      it 'should return false when not admin' do
        user.update_attribute(:role, 'staff')
        expect(user.admin?).to eq(false)
      end
    end

    describe '#staff?' do
      let(:role) { 'staff' }

      it 'should return true when staff' do
        expect(user.staff?).to eq(true)
      end

      it 'should return false when not staff' do
        user.update_attribute(:role, 'admin')
        expect(user.staff?).to eq(false)
      end
    end
  end
end
