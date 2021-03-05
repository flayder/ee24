# encoding : utf-8
require 'spec_helper'

describe Event do
  let!(:site) { create :prague_site }
  let!(:tag) { create(:tag, site: site) }
  let!(:event) { create :event, site: site }
  subject { event }

  before(:each) do
    event.tag_list = "#{tag.name}"
    event.save
    event.reload 
  end

  it { should be_valid }
  it { should validate_uniqueness_of(:text) }

  it_should_behave_like 'parameterized' do
    let(:subj) { subject }
  end

  it_should_behave_like 'with similar docs' do
    let(:doc) { event }
    let!(:similar_doc) { create :event, approved: true, rubric: event.rubric, site: event.site, tag_list: "#{tag.name}" }
  end

  it_behaves_like 'with moderation notification sending' do
    let(:model) { :event }
  end

  it_behaves_like 'approvable' do
    let(:obj) { event }
  end
end
