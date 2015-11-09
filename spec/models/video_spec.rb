require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '.search_by_title(query_string)' do
    let!(:family_guy) { Fabricate(:video, title: 'Family Guy') }
    let!(:family_friend) { Fabricate(:video, title: 'Family Friend') }

    it 'returns an empty array if no argument is passed' do
      expect(Video.search_by_title.to_a).to eql []
    end

    it 'returns an empty array if no video is found in a search' do
      expect(Video.search_by_title('groundhog').to_a).to eql []
    end

    it 'returns an array of one video for an exact match' do
      expect(Video.search_by_title('Family Guy').to_a)
        .to include family_guy
    end

    it 'returns an array of videos for a successful search' do
      expect(Video.search_by_title('family').to_a)
        .to include family_guy, family_friend
    end

    it 'returns search results ordered by newest first' do
      expect(Video.search_by_title('family').to_a)
        .to eq [family_friend, family_guy]
    end

    it 'returns an empty array of a search with an empty string' do
      expect(Video.search_by_title('').to_a).to eq []
    end
  end

  context 'review related tasks' do
    let(:video) { Fabricate(:video) }
    let!(:review1) do
      Fabricate(:review, video: video, rating: 1, created_at: 1.day.ago)
    end

    let!(:review2) do
       Fabricate(:review, video: video, rating: 1, created_at: 3.days.ago)
    end

    let!(:review3) do
       Fabricate(:review, video: video, rating: 2, created_at: 2.days.ago)
    end

    it 'returns the average rating from all reviews with 1 dec precision' do
      expect(video.avg_rating).to eq 1.3
    end

    it 'returns the average reviews-rating and igores nil-ratings' do
      review2.update_attribute(:rating, nil)
      expect(video.avg_rating).to eq 1.5
    end

    it 'returns the associated reviews in reverse order of creation' do
      expect(video.reviews).to eq [review1, review3, review2]
    end
  end
end

