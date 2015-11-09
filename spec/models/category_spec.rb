require 'spec_helper'

describe Category do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:videos) }

  describe '#recent_videos' do
    let(:comedies) { Category.create(name: 'Comedies') }

    it 'returns an empty collection if there are no videos in a category' do
      expect(comedies.recent_videos).to eq []
    end

    it 'returns all available videos if there are less than 6' do
      2.times { Fabricate(:video, category: comedies) }
      expect(comedies.recent_videos.size).to eq 2
    end

    it 'makes sure the ordering is by date' do
      v1 = Fabricate(:video, category: comedies, created_at: 2.days.ago)
      v2 = Fabricate(:video, category: comedies, created_at: 1.day.ago)

      expect(comedies.recent_videos.to_a).to eq [v2, v1]
    end

    it 'returns the last 6 videos ordered by date' do
      7.times { Fabricate(:video, category: comedies) }
      expect(comedies.recent_videos.count).to eq 6
    end

    it 'returns the most recent 6 videos' do
      6.times { Fabricate(:video, category: comedies) }
      v7 = Fabricate(:video, category: comedies, created_at: 2.days.ago)

      expect(comedies.recent_videos).not_to include v7
    end
  end
end

