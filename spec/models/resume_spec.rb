require 'spec_helper'

describe Resume do
  let(:resume) { create(:resume) }
  subject { resume }

  it { should be_valid }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:text) }

  it_behaves_like 'with moderation notification sending' do
    let(:model) { :resume }
  end

  it_behaves_like 'approvable' do
    let(:obj) { resume }
  end
end
