require 'spec_helper'

describe Invitation do
  it { is_expected.to belong_to(:inviter) }
  it { is_expected.to validate_presence_of(:inviter) }
  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:recipient_email) }
  it { is_expected.to validate_presence_of(:message) }

  it 'generates a random token' do
    Invitation.create(
      recipient_name: 'Ali Baba',
      recipient_email: 'valid@email.de',
      inviter: Fabricate(:user),
      message: 'Blah')
    expect(Invitation.first.token).to be_present
  end
end

