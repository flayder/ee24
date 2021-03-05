require 'spec_helper'

describe Vacancy do
  let(:vacancy) { create(:vacancy) }
  subject { vacancy }

  it { should be_valid }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:text) }

  it 'should validate professions size correctly (no professions)' do
    vacancy = build(:vacancy, :profession_ids => [])
    vacancy.save.should == false
    vacancy.errors[:professions].size.should eq(1)
  end

  it 'should validate professions size correctly (too much professions)' do
    prof_ids = create_professions(4)
    vacancy = build(:vacancy, :profession_ids => prof_ids)
    vacancy.save.should == false
    vacancy.errors[:professions].size.should eq(1)
  end

  it_behaves_like 'with moderation notification sending' do
    let(:model) { :vacancy }
  end

  it_behaves_like 'approvable' do
    let(:obj) { vacancy }
  end

  context 'with_photos' do
    let(:vacancy) { create(:vacancy, :with_photo) }
    subject { vacancy }

    its(:photos) { vacancy.photos.count.should eq(1) }
  end

  context 'with city' do
    let(:region) { create(:region) }

    it 'creates city' do
      vacancy.region_city_id = nil
      vacancy.region_id = region.id
      vacancy.region_city_title = 'new city'
      expect{vacancy.save}.to change(RegionCity, :count).by(1)
      expect(vacancy.region_city.title).to eq('new city')
      expect(vacancy.region_city.region_id).to eq(region.id)
    end
  end
end

def create_professions(size = 3)
  profs = []
  size.times do
    profs << create(:profession)
  end
  profs.map(&:id)
end
