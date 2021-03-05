require 'spec_helper'

describe MetrikaApiAccount::Url do
  let(:url) { create :metrika_api_account_url }
  subject { url }

  it { should be_valid }
  it { should belong_to(:metrika_api_account) }
  it { should validate_presence_of(:metrika_api_account_id) }
end