require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe '.search_by_title(query_string)' do
    before(:all) do
      @family_guy = Video.create(
        title: 'Family Guy',
        description: 'Explicit cartoon',
        created_at: 1.day.ago)

      @family_friend = Video.create(
        title: 'Family Friend',
        description: 'Wildly overrated movie')
    end

    after(:all) do
      @family_guy.destroy
      @family_friend.destroy
    end

    it 'returns an empty array if no argument is passed' do
      expect(Video.search_by_title.to_a).to eql []
    end

    it 'returns an empty array if no video is found in a search' do
      expect(Video.search_by_title('groundhog').to_a).to eql []
    end

    it 'returns an array of one video for an exact match' do
      expect(Video.search_by_title('Family Guy').to_a)
        .to include @family_guy
    end

    it 'returns an array of videos for a successful search' do
      expect(Video.search_by_title('family').to_a)
        .to include @family_guy, @family_friend
    end

    it 'returns search results ordered by newest first' do
      expect(Video.search_by_title('family').to_a)
        .to eq [@family_friend, @family_guy]
    end

    it 'returns an empty array of a search with an empty string' do
      expect(Video.search_by_title('').to_a).to eq []
    end
  end

  describe 'review related tasks' do
    let (:vertigo) { Fabricate(:video, title: 'Vertigo') }

    before do
      @review1 = Fabricate(:review, video: vertigo, rating: 1, created_at: 1.day.ago)
      @review2 = Fabricate(:review, video: vertigo, rating: 1, created_at: 3.day.ago)
      @review3 = Fabricate(:review, video: vertigo, rating: 2, created_at: 2.day.ago)
    end

    it 'returns the average rating from all reviews with 1 dec precision' do
      expect(vertigo.avg_rating).to eq 1.3
    end

    it 'returns the average reviews-rating and igores nil-ratings' do
      @review2.update_attribute(:rating, nil)
      expect(vertigo.avg_rating).to eq 1.5
    end

    it 'returns the associated reviews in reverse order of creation' do
      expect(vertigo.reviews).to eq [@review1, @review3, @review2]
    end
  end
end

