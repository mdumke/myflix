require 'spec_helper'

describe Video do
  it { should belong_to(:category) }

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
end

