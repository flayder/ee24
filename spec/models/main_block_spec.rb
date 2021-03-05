#encoding: utf-8
require 'spec_helper'

describe MainBlock do
  let!(:site) { create :site }
  let!(:doc_global_rubric) { create :doc_global_rubric, site: site }
  let!(:doc_rubric) { create :doc_rubric, global_rubric: doc_global_rubric, site: site }
  let!(:approved_doc) { create :doc, :approved, :main, rubric: doc_rubric, site: site }
  let!(:doc) { create :doc, rubric: doc_rubric, site: site }
  let!(:main_block) { create :main_block, doc_type: 'Doc', site: site }
  let!(:main_block_rubric) { create :main_block_rubric, rubric: doc_rubric, main_block: main_block }

  subject { main_block }

  it { should be_valid }

  describe '#docs' do
    it 'returns approved docs for main' do
      main_block.docs.should eq([approved_doc])
    end
  end

  describe 'uniq rubric_type' do
    let!(:event_rubric) { create :event_rubric }
    let(:main_block_with_other_rubric) { create :main_block_rubric, rubric: event_rubric, main_block: main_block }

    it 'invalid for not unique rubric_type' do
      main_block_with_other_rubric.should_not be_valid
      main_block_with_other_rubric.errors.messages[:rubric_type].should include('В блоке на главной должны быть рубрики только одного типа.')
    end
  end
end
