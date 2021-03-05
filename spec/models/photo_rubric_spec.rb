require 'spec_helper'

describe PhotoRubric do
  let(:photo_rubric) { create :photo_rubric }
  subject { photo_rubric }
  
  it { should be_valid }
end