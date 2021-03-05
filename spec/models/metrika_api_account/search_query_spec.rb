require 'spec_helper'

describe MetrikaApiAccount::SearchQuery do
  let(:query) { create :metrika_api_account_search_query }
  subject { query }

  it { should be_valid }
  it { should belong_to(:url) }
  it { should validate_presence_of(:url_id) }
end
