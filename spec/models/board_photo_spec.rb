require 'spec_helper'

describe BoardPhoto do
  let(:board_photo) { create :board_photo }
  subject { board_photo }

  it { should be_valid }
end
