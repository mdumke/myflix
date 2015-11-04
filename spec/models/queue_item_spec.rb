require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  it 'validates that queue_position is an integer' do
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

    context 'user has rated a video' do
      it 'returns the rating' do
        review1 = Fabricate(:review, rating: 3, text: 'abc', user: alice, video: video)
        queue_item = Fabricate(:queue_item, user: alice, video: video)

        expect(queue_item.rating).to eq 3 
      end

      it 'returns the first rating if there are many' do
        review1 = Fabricate(:review, rating: 3, text: 'abc', user: alice, video: video)
        review2 = Fabricate(:review, rating: 3, text: 'abc', user: alice, video: video)
        queue_item = Fabricate(:queue_item, user: alice, video: video)

        expect(queue_item.rating).to eq 3 
      end
    end

    context 'user has not yet rated a video' do
      it 'returns nil' do
        queue_item = Fabricate(:queue_item, user: alice, video: video)

        expect(queue_item.rating).to be_nil
      end
    end
  end
end

