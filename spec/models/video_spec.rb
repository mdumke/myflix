require 'spec_helper'

describe Video do
  it 'saves correctly' do
    video = Video.new(title: 'Dirty Harry')

    video.save

    expect(Video.find_by_title('Dirty Harry')).to eq video
  end
end

