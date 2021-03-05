require 'spec_helper'

describe DocGlobalRubric do
  let(:doc_global_rubric) { create :doc_global_rubric }
  subject { doc_global_rubric }
  
  it { should be_valid }
  it { should have_many(:doc_rubrics).dependent(:destroy) }
end
