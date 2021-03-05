require 'spec_helper'

describe RubricPermission do
  let(:rubric_permission) { create :rubric_permission }
  subject { rubric_permission }
  
  it { should be_valid }
  it { should belong_to(:site_admin) }
  it { should belong_to(:rubric) }
end