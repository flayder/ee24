# encoding : utf-8
require 'spec_helper'

describe SiteAdmin do
  let(:site_admin) { create :site_admin }
  subject { site_admin }

  it { should be_valid }
  it { should have_many(:rubric_permissions) }

  describe 'permissions' do
    let(:news) { create(:section, :title => 'news') }
    let(:afisha) { create(:section, :title => 'afisha') }
    let(:job) { create(:section, :title => 'job') }
    let(:site_editor) do
      create(:site_editor, :section_ids => [news.id, afisha.id])
    end

    it 'should assign permissions properly' do
      site_editor.permissions.where(
        :section_id => [news.id, afisha.id]
      ).count.should == 2
      site_editor.permissions.where(:section_id => job.id).should be_empty
    end

    describe '#set_permissions' do
      context 'when add sections' do
        it 'assings permissions for sections' do
          site_editor.permissions.count.should eq(2)
        end
      end

      context 'when delete sections' do
        before do
          site_editor.section_ids = []
          site_editor.save
        end

        it 'remove all permissions' do
          site_editor.permissions.should be_empty
        end
      end
    end
  end

  describe '#old_rubric_permissions_attributes=' do
    let(:doc_rubric) { create :doc_rubric }

    it 'creates RubricPermission' do
      lambda {
        site_admin.rubric_permissions_attributes = [
          {
            'rubric_type' => 'DocRubric',
            'rubric_id' => doc_rubric.id
          }
        ]
        site_admin.save
      }.should change(RubricPermission, :count).by(1)
    end

    context 'when updating existing permissions' do
      let!(:rubric_permissions) { create_list(:rubric_permission, 2, :site_admin => site_admin) }

      it 'deletes unchecked RubricPermission' do
        lambda {
          site_admin.rubric_permissions_attributes = [
            {
              'rubric_type' => 'DocRubric',
              'rubric_id' => rubric_permissions.first.rubric_id
            }
          ]
          site_admin.save
        }.should change(RubricPermission, :count).by(-1)
      end
    end
  end
end
