require 'spec_helper'

describe Relationship do
  it { is_expected.to validate_presence_of(:leader) }
  it { is_expected.to validate_presence_of(:follower) }
end

