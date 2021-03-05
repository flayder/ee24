require 'spec_helper'

describe SocialWidgetCode do
  let(:site) { create :site }
  let(:social_widget_code) { create :social_widget_code, :site_id => site.id }
  
  subject { social_widget_code }

  it { should be_valid }
  it { should belong_to(:site) }
end
