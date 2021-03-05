require 'spec_helper'

describe MetrikaApiAccount do
  let(:metrika) { create :metrika_api_account }
  subject { metrika }

  it { should be_valid }
  it { should belong_to(:site) }
  it { should have_many(:urls).dependent(:destroy) }
end