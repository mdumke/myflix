require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  it { should have_many(:videos) }

  describe '#recent_videos' do
    it 'returns an empty collection if there are not videos in a category' do
      c1 = Category.new(name: 'c1')

      expect(c1.recent_videos).to eq []
    end

    it 'returns all available videos if there are less than 6' do
      c1 = Category.create(name: 'c2')
      v1 = Video.create(title: '1', description: 'd', category: c1, created_at: 1.day.ago)
      v2 = Video.create(title: '2', description: 'd', category: c1, created_at: 2.days.ago)
       
      expect(c1.recent_videos.size).to eq 2
    end

    it 'makes sure the ordering is by date' do
      c1 = Category.create(name: 'c2')
      v1 = Video.create(title: '1', description: 'd', category: c1, created_at: 2.day.ago)
      v2 = Video.create(title: '2', description: 'd', category: c1, created_at: 1.days.ago)
       
      expect(c1.recent_videos.to_a).to eq [v2, v1]
    end

    it 'returns the last 6 videos ordered by date' do
      c1 = Category.create(name: 'c1')

      v1 = Video.create(title: '1', description: 'd', category: c1, created_at: 1.day.ago)
      v2 = Video.create(title: '2', description: 'd', category: c1, created_at: 2.days.ago)
      v3 = Video.create(title: '3', description: 'd', category: c1, created_at: 3.days.ago)
      v4 = Video.create(title: '4', description: 'd', category: c1, created_at: 4.days.ago)
      v5 = Video.create(title: '5', description: 'd', category: c1, created_at: 5.days.ago)
      v6 = Video.create(title: '6', description: 'd', category: c1, created_at: 6.days.ago)
      v7 = Video.create(title: '7', description: 'd', category: c1, created_at: 7.days.ago)

      expect(c1.recent_videos.to_a).to eq [v1, v2, v3, v4, v5, v6]
    end

    it 'returns the most recent 6 videos' do
      comedies = Category.create(name: 'Comedies')

      6.times { Video.create(title: 'foo', description: 'bar', category: comedies) }
      earlier_video = Video.create(title: 'foo', description: 'bar', category: comedies, created_at: 10.days.ago)

      expect(comedies.recent_videos).not_to include earlier_video
    end
  end
end

