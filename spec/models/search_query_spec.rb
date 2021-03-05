require 'spec_helper'

describe SearchQuery do
  let(:query) { create :search_query }

  subject { query }

  it { should be_valid }
  it { should belong_to(:site) }
end
