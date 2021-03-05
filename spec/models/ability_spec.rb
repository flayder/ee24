# encoding : utf-8
require 'spec_helper'
require 'cancan/matchers'

def should_not_be_able_to_become_user ability
  ability.can?(:become, User).should be_falsey
end

describe Ability do
  let!(:site) { create :site }
  let(:admin_user) { create :admin }
  let(:ability) { Ability.new admin_user, site.id }

  describe 'superadmin permissions' do
    [DictionaryObject, DictionaryRubric, Seo].each do |klass|
      it "should allow to manage #{klass.name}" do
        ability.can?(:manage, klass).should be_truthy
      end
    end

    it 'should be able to become user' do
      ability.can?(:become, User).should be_truthy
    end
  end

  describe 'admin permissions' do
    let(:user) { create :user }
    let!(:site_admin) { create :site_admin, :user => user, :site => site }
    let(:ability) { Ability.new(user, site.id) }

    subject { ability }

    before(:each) do
      site.site_admins.create(:user_id => user.id, :role => 'admin')
    end

    it "should not allow another site admin to create docs" do
      satellite = create(:satellite)
      Ability.new(user, satellite.id).can?(:create, :docs).should be_falsey
    end

    [DictionaryObject, DictionaryRubric, Seo].each do |klass|
      it "should allow to manage #{klass.name}" do
        ability.can?(:manage, klass).should be_truthy
      end
    end

    it { should_not_be_able_to_become_user ability }
  end

  describe 'moderator permissions' do
    let(:user) { create :user }
    let!(:site_admin) { create :site_admin, :role => 'moderator', :user => user, :site => site }
    let(:ability) { Ability.new(user, site.id) }
    subject { ability }
    let(:doc) { create :doc, :site => site }
    let(:doc) { create :doc, :site => site }

    before do
      create_default_sections(site)
    end

    it 'should manage own doc' do
      doc.user = user
      Permission.create(:site_admin_id => site_admin.id, :section => Section.find_by_controller('docs'))
      ability.can?(:rest_manage, doc).should be_truthy
    end

    it 'should not be able to manage docs' do
      ability.can?(:manage, create(:doc)).should be_falsey
    end

    it 'should manage own doc' do
      ability.can?(:manage, doc).should be_falsey
    end

    context 'external_docs' do
      let(:docs_sections) { create :section, :controller => :docs }
      let!(:site_section) { create :site_section, :section => docs_sections,
                                   :site => site }
      let!(:external_doc_rubric) { create :external_doc_rubric, :site => site }
      let!(:rubric_permission) { create :rubric_permission,
                                        :site_admin => site_admin,
                                        :rubric => external_doc_rubric }
      let!(:external_doc) { create :external_doc,
                                   :rubric => external_doc_rubric,
                                   :site => site }

      it 'not allows edit external_docs of rubric' do
        ability.can?(:manage, external_doc).should be_falsey
      end
    end
  end

  describe 'editor permissions' do
    let(:user) { create(:editor) }
    let!(:site_editor) { create :site_editor, :site => site, :user => user }
    let(:docs_section) { create :section, :controller => 'docs' }
    let(:ability) { Ability.new(user, site.id) }

    context 'with permissions' do
      it "should allow editor to create docs" do
        Permission.create(:site_admin_id => site_editor.id, :section_id => docs_section.id)
        ability.can?(:manage, Doc).should be_truthy
      end

      it 'should be able to ban users' do
        ability.can?(:toggle_ban, User).should be_truthy
      end

      it { should_not_be_able_to_become_user ability }
    end

    context 'without permissions' do
      it 'should be able to manage dictionary object' do
        ability.can?(:manage, DictionaryObject).should be_falsey
      end

      it 'should be able to manage dictionary rubric' do
        ability.can?(:manage, DictionaryRubric).should be_falsey
      end

      it { should_not_be_able_to_become_user ability }
    end

    [Seo].each do |klass|
      it "should not allow to manage #{klass.name} without permissions" do
        ability.can?(:manage, klass).should be_falsey
      end
    end

    context 'with rubric_permission' do
      context 'for docs' do
        let(:doc_rubric) { create :doc_rubric, :site => site }
        let(:docs_sections) { create :section, :controller => :docs }
        let!(:site_section) { create :site_section, :section => docs_sections, :site => site }
        let!(:rubric_permission) { create :rubric_permission, :site_admin => site_editor, :rubric => doc_rubric }
        let!(:doc) { create :doc, :rubric => doc_rubric, :site => site }
        let!(:other_doc) { create :doc, :site => site }

        it 'allows edit docs doc of rubric' do
          ability.can?(:manage, doc).should be_truthy
        end

        it 'does not allow edit docs doc of rubric' do
          ability.can?(:manage, other_doc).should be_falsey
        end
      end

      context 'for external_docs' do
        let(:docs_sections) { create :section, :controller => :docs }
        let!(:site_section) { create :site_section, :section => docs_sections,
                                     :site => site }
        let!(:external_doc_rubric) { create :external_doc_rubric, :site => site }
        let!(:rubric_permission) { create :rubric_permission,
                                          :site_admin => site_editor,
                                          :rubric => external_doc_rubric }
        let!(:external_doc) { create :external_doc,
                                     :rubric => external_doc_rubric,
                                     :site => site }

        it 'allows edit external_docs of rubric' do
          ability.can?(:manage, external_doc).should be_truthy
        end
      end
    end
  end

  describe 'user permissions' do
    let(:user) { create :user }
    let(:ability) { Ability.new(user, site.id) }

    [DictionaryObject, DictionaryRubric, Seo].each do |klass|
      it "should not allow to manage #{klass.name}" do
        ability.can?(:manage, klass).should be_falsey
      end
    end

    context 'for DictionaryObject' do
      let(:approved_dictionary_object) { create :dictionary_object, :approved => true }
      let(:unapproved_dictionary_object) { create :dictionary_object, :approved => false }

      it 'should be able to read approved DictionaryObject' do
        ability.can?(:read, approved_dictionary_object).should be_truthy
      end

      it 'should not be able to read unapproved DictionaryObject' do
        ability.can?(:read, unapproved_dictionary_object).should be_falsey
      end
    end

    context 'for Friendship' do
      let(:friend) { create :user }
      let(:other_user) { create :user }
      before { user.friends << friend }
      subject { ability }

      it { should be_able_to(:del_friend, friend) }
      it { should_not be_able_to(:del_friend, other_user) }
    end
  end

  describe 'observer permissions' do
    context 'on observer site' do
      let(:observer) { create :site_observer, :site => site }
      let(:ability) { Ability.new observer.user, site.id }
      let(:doc) { create :doc, :site => site }
      subject { ability }

      it { should be_able_to(:view_ip, doc) }
    end

    context 'not on observer site' do
      let(:observer) { create :site_observer }
      let(:ability) { Ability.new observer.user, site.id }
      let(:doc) { create :doc }
      subject { ability }

      it { should_not be_able_to(:view_ip, doc) }
    end
  end
end
