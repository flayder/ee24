# encoding : utf-8
require 'spec_helper'

describe Doc do
  let!(:site) { create :prague_site }
  let!(:global_rubric) { create :doc_global_rubric, site: site }
  let!(:rubric) { create :doc_rubric, global_rubric: global_rubric, site: site }
  let!(:doc) { create :doc, :approved, rubric: rubric, site: site }

  subject { doc }

  it { should be_valid }

  its(:param) { should_not be_nil }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:doc_rubric_id) }
  it { should validate_uniqueness_of(:text) }

  describe 'with versions', :versioning => true do

    before(:each) do
      PaperTrail.controller_info = {:site_id => site.id}
      PaperTrail.whodunnit = doc.user_id
    end

    it 'should create versions on create' do
      doc.versions.size.should eq(1)
      doc.versions.first.event.should eq('create')
    end

    it 'should create version on update' do
      doc.title = 'hello'
      doc.save
      doc.versions.size.should eq(2)
      doc.versions.unscoped.last.event.should eq('update')
    end

    it 'should create version on delete' do
      doc.destroy
      Version.unscoped.last.event.should eq('destroy')
    end

  end

  it_should_behave_like 'parameterized' do
    let(:subj) { subject }
  end

  context 'unapproved' do
    it_behaves_like 'with moderation notification sending' do
      let(:model) { :doc }
    end
  end

  it_behaves_like 'approvable' do
    let(:obj) { create :doc }
  end

  it_should_behave_like 'previewable' do
    let(:subj) { subject }
  end

  describe 'approving' do
    let(:doc) { build :doc }
    subject { doc }

    it { should_not be_approved }
    its(:approved_at) { should be_nil }

    context 'when approved is set' do
      before do
        doc.approved = true
        doc.valid?
      end

      its(:approved_at) { should_not be_nil }
    end
  end

  describe 'important' do
    before do
      doc.important = true
      doc.valid?
    end

    its(:important) { should be_truthy }
  end

  describe 'tagged' do
    let!(:tag) {create(:tag, site: site)}
    let!(:tag1) {create(:tag, site: site)}

    it 'has tags with order' do
      doc.tag_list = "#{tag1.name}, #{tag.name}"
      doc.save
      doc.reload
      expect(doc.tag_list).to eq([tag1.name, tag.name])
    end

    it 'saves tags with other order' do
      doc.tag_list = "#{tag.name}, #{tag1.name}"
      doc.save
      doc.reload
      expect(doc.tag_list).to eq([tag.name, tag1.name])
    end

    it 'saves tags w#{tag.name}ith order second time' do
      doc.tag_list = "#{tag.name}, #{tag1.name}"
      doc.save
      doc.tag_list = "#{tag1.name}, #{tag.name}"      
      doc.save
      doc.reload
      expect(doc.tag_list).to eq([tag1.name, tag.name])
    end

    context 'similar' do
      #искать по tag1
      let!(:doc2) {create(:doc, approved: true, tag_list: "#{tag1.name}", site: site)}
      let!(:doc3) {create(:doc, approved: true, tag_list: "#{tag.name}", site: site)}
      let!(:site2) {create(:site)}
      let!(:doc4) {create(:doc, site: site2, approved: true, tag_list: "#{tag1.name}")}
    
      before(:each) do
        doc.tag_list = "#{tag1.name}, #{tag.name}"      
        doc.save
        doc.reload
      end

      it 'has proper similar docs' do
        expect(doc.similar_docs).to include(doc2)
        expect(doc.similar_docs).to_not include(doc3)
        expect(doc.similar_docs).to_not include(doc4)
      end
    end

    context 'new tags' do
      before(:each) do
        doc.tag_list = "#{tag.name}, #{tag1.name}"
        doc.save
        doc.reload
      end

      it 'does not allow to add new tag' do
        doc.tag_list = "#{tag.name}, #{tag1.name}, other_tag"
        expect(doc.save).to be_truthy
        doc.reload
        expect(doc.tag_list).to eq([tag.name, tag1.name])
      end

      it 'does not create same tag in other case' do
        some_tag = create(:tag, site: site, name: 'Биометрика')
        doc.tag_list = "биометрика"
        doc.save
        doc.reload
        expect(doc.save).to be_truthy
        expect(doc.tags).to eq([some_tag])
      end
    end

  end

end
