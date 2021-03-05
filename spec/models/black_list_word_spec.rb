require 'spec_helper'

describe BlackListWord do
  let(:word) { create :black_list_word }
  subject { word }

  it { should be_valid }
end
