require 'spec_helper'

describe Video do
  it 'saves correctly' do
    video = Video.new(title: 'Dirty Harry')

    video.save

    expect(Video.find_by_title('Dirty Harry')).to eq video
  end

  it 'can have a category' do
    category = Category.new(name: 'Western')
    video = Video.new(title: 'Stagecoach', category: category)

    video.save

    expect(Video.first.category).to eq category
  end
end

