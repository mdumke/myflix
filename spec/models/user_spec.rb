require 'spec_helper'

describe User, type: :model do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }

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
      password: '1234',
      password_confirmation: '1234')

    expect(u.valid?).to be_truthy
  end

  context 'on queue item operations' do
    let (:alice) { Fabricate(:user) }

    it 'returns queue items ordered by queue-position' do
      item1 = Fabricate(:queue_item, user: alice, queue_position: 2)
      item2 = Fabricate(:queue_item, user: alice, queue_position: 3)
      item3 = Fabricate(:queue_item, user: alice, queue_position: 1)

      expect(alice.queue_items).to eq [item3, item1, item2]
    end  
  end
end

