require 'spec_helper'

describe Category do
  it 'saves itself' do
    cat = Category.new(name: 'Existencial Drama')

    cat.save

    expect(Category.first).to eq cat
  end

  it 'can have multiple videos' do
    v1 = Video.new(title: 'Ghostbusters')
    v2 = Video.new(title: 'I was born but...')

    Category.create(name: 'test', videos: [v1, v2])
  
    expect(Category.first.videos).to eq [v1, v2]
  end
end

