require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe 'getting the rating for a video' do
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

