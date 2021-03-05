require 'spec_helper'

describe ExternalDocRubric do
  let!(:rubric) { create :external_doc_rubric }
  subject { rubric }

  it { should be_valid }
end
