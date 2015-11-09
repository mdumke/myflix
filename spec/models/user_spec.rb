require 'spec_helper'

describe User, type: :model do
  let(:alice) { Fabricate(:user) }
  let(:new_user) { User.new(full_name: 'n', email: 'a@b', password: '123') }

  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it 'does not complain about missing confirmation' do
    expect(new_user.valid?).to be_truthy
  end

  it 'checks password confirmation if confirmation is given' do
    new_user.password_confirmation = '234'
    expect(new_user.valid?).to be_falsy
  end

  it 'is valid if password and confirmation match' do
    new_user.password_confirmation = '123'
    expect(new_user.valid?).to be_truthy
  end

  it 'returns queue items ordered by queue-position' do
    [2, 3, 1].each do |position|
      Fabricate(:queue_item, user: alice, queue_position: position)
    end
    expect(alice.queue_items.map(&:queue_position)).to eq [1,2,3]
  end

  describe '#queue_length' do
    it "returns the amount of the user's queue items" do
      alice = Fabricate(:user)
      2.times { Fabricate(:queue_item, user: alice) }
      expect(alice.queue_length).to eq 2
    end
  end

  describe '#has_queued?(video)' do
    let(:video) { Fabricate(:video) }
    let!(:queue_item) { Fabricate(:queue_item, user: alice, video: video) }

    it 'returns true if video is already in the queue' do
      expect(alice.has_queued?(video)).to be_truthy
    end

    it 'returns false if video is not already in the queue' do
      expect(alice.has_queued?(Fabricate(:video))).to be_falsy
    end
  end
end

