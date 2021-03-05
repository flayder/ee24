require 'spec_helper'

describe Permission do
  let(:permission) { create :permission } 
  subject { permission }
  
  it { should be_valid }

  it { should belong_to :site_admin }
  it { should belong_to :section }
  it { should validate_uniqueness_of(:site_admin_id).scoped_to(:section_id)}
end