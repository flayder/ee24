require 'spec_helper'

describe CatalogRubric do
  let(:catalog_rubric) { create :catalog_rubric }
  subject { catalog_rubric }

  it { should be_valid }
  it { should have_many :catalogs }

  describe 'counters' do
    let(:site) { create :site }
    let(:catalog_rubric_1) { create :catalog_rubric, site: site }
    let(:catalog_rubric_2) { create :catalog_rubric, parent: catalog_rubric_1, site: site }
    let(:catalog_rubric_3) { create :catalog_rubric, parent: catalog_rubric_2, site: site }

    it 'zero by default' do
      catalog_rubric_1.counter.should eq(0)
      catalog_rubric_2.counter.should eq(0)
      catalog_rubric_3.counter.should eq(0)
    end

    describe 'approve catalog' do
      it 'increases counter for each rubric in a tree' do
        i = rand(3..5)

        i.times { create(:catalog, :approved, rubric: catalog_rubric_3, site: site) }

        catalog_rubric_1.reload.counter.should eq(i)
        catalog_rubric_2.reload.counter.should eq(i)
        catalog_rubric_3.reload.counter.should eq(i)

        Catalog.all.each do |c|
          c.approved = false
          c.save
        end

        catalog_rubric_1.reload.counter.should eq(0)
        catalog_rubric_2.reload.counter.should eq(0)
        catalog_rubric_3.reload.counter.should eq(0)
      end
    end

    describe 'disapprove catalog' do
      let!(:catalog) { create :catalog, :approved, rubric: catalog_rubric_3, site: site }

      before do
        catalog.approved = false
        catalog.approved_at = nil
        catalog.save
      end

      it 'decreases counter for each rubric in a tree' do
        catalog_rubric_1.reload.counter.should eq(0)
        catalog_rubric_2.reload.counter.should eq(0)
        catalog_rubric_3.reload.counter.should eq(0)
      end
    end

    context 'when catalogs are destroyed' do
      it 'decreases counter for rubric' do
        i = rand(3..5)

        i.times { create(:catalog, :approved, rubric: catalog_rubric_3, site: site) }

        catalog_rubric_1.reload.counter.should eq(i)
        catalog_rubric_2.reload.counter.should eq(i)
        catalog_rubric_3.reload.counter.should eq(i)

        Catalog.destroy_all

        catalog_rubric_1.reload.counter.should eq(0)
        catalog_rubric_2.reload.counter.should eq(0)
        catalog_rubric_3.reload.counter.should eq(0)
      end
    end

    context 'when rubric is changed' do
      let!(:catalog) { create :catalog, :approved, :rubric => catalog_rubric_1, :site => site }

      before do
        catalog.rubrics << catalog_rubric_2
      end

      it 'increases current rubric counter' do
        catalog_rubric_2.reload.counter.should eq(1)
      end

      it 'former rubric counter should not change' do
        catalog_rubric_1.counter.should eq(1)
      end
    end
  end
end
