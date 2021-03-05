# encoding : utf-8
require 'spec_helper'

describe Site do
  let(:site) { create :site }
  subject { site }

  it { should be_valid }
  it { should have_one(:metrika_api_account).dependent(:destroy) }
  it { should have_many(:seos).dependent(:destroy) }
  it { should have_many(:events).dependent(:destroy) }
  it { should have_many(:docs).dependent(:destroy) }
  it { should have_many(:site_admins).dependent(:destroy) }
  it { should have_many(:site_sections).dependent(:destroy) }
  it { should have_many(:static_docs).dependent(:destroy) }
  it { should have_many(:search_queries).dependent(:destroy) }
  it { should have_many(:tags).dependent(:destroy) }
  it { should have_many(:users) }

  its(:section_ids) { should be_empty }
  its(:robots) { should_not be_empty }
  its(:forecast_settings) { should be }

  describe '#email' do
    let(:site) { Site.new }
    subject { site }

    its(:email) { should eq('info@36on.ru') }

    it 'is not invalid' do
      site.email = 'wrong_email'
      site.should_not be_valid
    end

    it 'could be blank' do
      site.email = ""
      site.should_not be_valid
    end
  end

  describe '#portal_title' do
    it 'should return short_title if portal_title is nil' do
      site.update_attribute(:portal_title, nil)
      site.portal_title.should eq(site.short_title)
    end
  end

  describe '.voronezh_id' do
    it { Site.voronezh_id.should eq(1)}
  end

  it 'should be valid with just subdomain' do
    site.domain = nil
    site.should be_valid
  end

  it 'should be valid with just domain' do
    site.subdomain = nil
    site.should be_valid
  end

  it 'should not be valid without domain and subdomain' do
    site.subdomain = nil
    site.domain = nil
    site.should_not be_valid
  end

  context 'when partner' do
    let(:partner_site) { create :partner_site }

    before(:each) do
      create_default_sections site
    end

    it 'should has default sections after create' do
      partner_site.sections.map(&:controller).should eq(
        ['afisha', 'catalog', 'job']
      )
    end

    describe '#assign_default_rubrics_async' do
      let!(:partner_site) { create :partner_site }

      before { ResqueSpec.reset! }

      it 'should create delayed job' do
        partner_site.assign_default_rubrics_async
        DefaultRubricGeneratorJob.should have_queue_size_of(1)
      end
    end
  end

  describe '#destroy' do
    let!(:partner_site) { create :partner_site }
    let(:site_sections_count) { partner_site.site_sections.count }
    let(:site_admins_count) { partner_site.site_admins.count }

    before :each do
      partner_site.site_admins << create(:site_admin)
      partner_site.assign_default_rubrics!
    end

    it 'should destroy site_admins' do
      lambda do
        partner_site.destroy
      end.should change(SiteAdmin, :count).by(-site_admins_count)
    end

    it 'should destroy site_section' do
      lambda do
        partner_site.destroy
      end.should change(SiteSection, :count).by(-site_sections_count)
    end

    # context 'site with rubrics' do
    #   let!(:site) { create :site }
    #   let!(:doc_section) { create :section, :controller => 'docs' }
    #   let!(:site_section) { create :site_section, :site => site, :section => doc_section }
    #   let!(:rubric_doc) { create :rubric_doc, :site => site }
    #   let!(:doc) { create :doc, :site => site, :rubric => rubric_doc }

    #   let!(:catalog_section) { create :section, :controller => 'catalog' }
    #   let!(:catalog_site_section) { create :site_section, :site => site, :section => catalog_section }
    #   let!(:catalog_global_rubric) { create :catalog_global_rubric, :site => site }
    #   let!(:parent_catalog_global_rubric) { create :catalog_global_rubric, :parent_id => catalog_global_rubric.id, :site => site }
    #   let!(:catalog) { create :catalog, :site => site, :rubric => catalog_global_rubric }

    #   it 'deletes site_sections' do
    #     lambda {
    #       site.destroy
    #     }.should change(SiteSection, :count).by(-2)
    #   end

    #   it 'deletes rubric_doc' do
    #     lambda {
    #       site.destroy
    #     }.should change(RubricDoc, :count).by(-1)
    #   end

    #   it 'deletes doc' do
    #     lambda {
    #       site.destroy
    #     }.should change(Doc, :count).by(-1)
    #   end

    #   it 'deletes catalog' do
    #     lambda {
    #       site.destroy
    #     }.should change(Catalog, :count).by(-1)
    #   end

    #   it 'delete catalog global rubrics which doen not belong to other site' do
    #     lambda {
    #       site.destroy
    #     }.should change(CatalogGlobalRubric, :count).by(-2)
    #   end
    # end
  end
end
