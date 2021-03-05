require 'spec_helper'

describe Message do
  let(:message) { create :message }
  subject { message }

  it { should be_valid }

  it 'does not valid when sender and receiver are the same' do
    message.receiver = message.sender
    message.should_not be_valid
  end
end
