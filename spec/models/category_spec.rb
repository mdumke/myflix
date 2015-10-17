require 'spec_helper'

describe Category do
  it 'saves itself' do
    cat = Category.new(name: 'Existencial Drama')

    cat.save

    expect(Category.first).to eq cat
  end

  it 'can have multiple videos' do
    v1 = Video.new(
      title: 'Ghostbusters',
      description: 'something with ghosts')

    v2 = Video.new(
      title: 'I was born but...',
      description: 'something with a boy')

    Category.create(name: 'test', videos: [v1, v2])
  
    expect(Category.first.videos).to include v1, v2
  end

  it 'is invalid without a name' do
    category = Category.new

    expect(category.valid?).to be_falsy
  end
end
