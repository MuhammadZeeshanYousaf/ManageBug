require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new(role: :manager, name: 'John Doe', email: 'john.doe@email.com', password: '123456', phone_number: '123-456-7890') }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a role' do
      user.role = nil
      expect(user).not_to be_valid
      expect(user.errors[:role]).to include("can't be blank")
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without email' do
      user.email = nil
      expect(user).to_not be_valid
      user.email = ''
      expect(user).to_not be_valid
    end

    it 'is not valid without password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'is valid for password >= 6 characters' do
      user.password = '123456'
      expect(user).to be_valid
      user.password = '12345678'
      expect(user).to be_valid
    end

    it 'is not valid for password < 6 characters' do
      user.password = '12345'
      expect(user).to_not be_valid
    end

    it 'is not valid with a name shorter than 3 characters' do
      user.name = 'Ab'
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too short (minimum is 3 characters)')
    end

    it 'is not valid with a name longer than 30 characters' do
      user.name = 'a' * 31
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too long (maximum is 30 characters)')
    end

    it 'is not valid without a phone_number' do
      user.phone_number = nil
      expect(user).not_to be_valid
      expect(user.errors[:phone_number]).to include("can't be blank")
    end
  end
end
