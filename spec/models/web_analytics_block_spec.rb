require 'spec_helper'

describe WebAnalyticsBlock do
  let(:site) { create :site }
  let(:web_analytics_block) { create :web_analytics_block, :site_id => site.id }
  
  subject { web_analytics_block }

  it { should be_valid }
  it { should belong_to(:site) }
end
