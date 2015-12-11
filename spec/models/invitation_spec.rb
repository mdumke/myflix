require 'spec_helper'

describe Invitation do
  it { is_expected.to belong_to(:inviter) }
  it { is_expected.to belong_to(:recipient) }
  it { is_expected.to validate_presence_of(:inviter) }
  it { is_expected.to validate_presence_of(:recipient) }
  it { is_expected.to validate_presence_of(:message) }
end

