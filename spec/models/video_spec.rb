require 'spec_helper'

describe Video do
  it 'saves correctly' do
    video = Video.new(
      title: 'Dirty Harry',
      description: 'Do you feel lucky, Punk?')

    video.save

    expect(Video.find_by_title('Dirty Harry')).to eq video
  end

  it 'can have a category' do
    category = Category.new(name: 'Western')
    
    video = Video.new(
      title: 'Stagecoach',
      description: 'nice and not weird movie',
      category: category)

    video.save

    expect(Video.first.category).to eq category
  end

  it 'is invalid without a title' do
    video = Video.new(description: 'a movie about something important')

    expect(video.valid?).to be_falsy
  end

  it 'is invalid without a description' do
    video = Video.new(title: 'Audition')

    expect(video.valid?).to be_falsy
  end
end

