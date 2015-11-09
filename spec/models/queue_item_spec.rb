require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  it 'validates that queue_position is an integer' do
    # Note: shoulda-matches fail to test Numericality
    queue_item = Fabricate(:queue_item)
    queue_item.queue_position = 2.4
    queue_item.valid?
    expect(queue_item.errors[:queue_position]).not_to be_blank
  end

  describe '#video_title' do
    it 'returns the title of the associated video' do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq video.title
    end
  end

  describe '#category' do
    it 'returns the category of the associated video' do
      comedies = Fabricate(:category, name: 'comedies')
      video = Fabricate(:video, category: comedies)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq comedies
    end
  end

  describe '#rating' do
    let (:alice) { Fabricate(:user) }
    let (:video) { Fabricate(:video) }

    it 'returns the rating' do
      Fabricate(:review, rating: 3, user: alice, video: video)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      expect(queue_item.rating).to eq 3
    end

    it 'returns the first rating if there are many' do
      Fabricate(:review, rating: 3, user: alice, video: video)
      Fabricate(:review, rating: 4, user: alice, video: video)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      expect(queue_item.rating).to eq 3
    end

    it 'returns nil when user has not rated a video' do
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe '#rating=' do
    let (:alice) { Fabricate(:user) }
    let (:video) { Fabricate(:video) }

    it 'updates the corresponding review' do
      review = Fabricate(:review, user: alice, video: video)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      queue_item.rating = 4
      expect(review.reload.rating).to eq 4
    end

    it 'updates the rating to nil when nil is given' do
      review = Fabricate(:review, user: alice, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      queue_item.rating = nil
      expect(review.reload.rating).to eq nil
    end

    it 'updates the rating to nil when empty string is given' do
      review = Fabricate(:review, user: alice, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      queue_item.rating = ''
      expect(review.reload.rating).to eq nil
    end

    it 'returns nil when update fails' do
      Fabricate(:review, user: alice, video: video)
      queue_item = Fabricate(:queue_item, user: alice, video: video)
      result = queue_item.send(:rating=, -1)
      expect(result).to be_nil
    end
  end
end

