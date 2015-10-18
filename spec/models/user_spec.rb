require 'spec_helper'

describe User, type: :model do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it 'does not complain about missing confirmation' do
    u = User.create(
      full_name: 'Hans Vollmeise', 
      email: 'Hans@Vollmeise.com',
      password: '123')

    expect(u.valid?).to be_truthy
  end

  it 'checks password confirmation if confirmation is given' do
    u = User.create(
      full_name: 'Hans Vollmeise', 
      email: 'Hans@Vollmeise.com',
      password: '123',
      password_confirmation: '234')

    expect(u.valid?).to be_falsy
  end

  it 'is valid if password and confirmation match' do
    u = User.create(
      full_name: 'Hans Vollmeise', 
      email: 'Hans@Vollmeise.com',
      password: '123',
      password_confirmation: '123')

    expect(u.valid?).to be_truthy
  end
end

