# encoding: utf-8
require 'spec_helper'

describe ActsAsTaggableOn::Tag do
  let(:tag) { create :tag }
  let!(:site) { create(:site) }
  subject { tag }
  
  it { should be_valid }
  it { should belong_to(:site) }
  it { should validate_presence_of(:site_id) }
  it { skip('****** FIX IT ******'); should validate_uniqueness_of(:name).scoped_to(:site_id) }

  it 'generates link for new tag' do
    new_tag = create(:tag, name: 'товарищ')
    expect(new_tag.link).to eq('tovarisch')
  end

  it 'sets manually added link' do
    new_tag = create(:tag, link: 'comrade', name: 'товарищ')
    new_tag.reload
    expect(new_tag.link).to eq('comrade')
  end

  it 'does not regenerate link when updated' do
    new_tag = create(:tag, link: 'comrade', name: 'товарищ')
    new_tag.name = 'товарищ2'
    new_tag.save!
    new_tag.reload
    expect(new_tag.link).to eq('comrade')
  end

  context 'uniqueness' do
    let!(:uniq_tag) {create(:tag, site: site, name: 'Воронежский Воронеж')}
  
    it 'validates uniqueness' do
      tag2 = build(:tag, site: site, name: 'воронежскиЙ Воронеж')
      expect(tag2.valid?).to be_falsey
      tag2.errors[:name].size.should eq(1)
      tag2.errors[:link].size.should eq(1)
    end
  end

  context 'seo' do
    let!(:tag1) { create(:tag, link: 'comrade', name: 'товарищ', site: site) }
    let!(:seo) { create(:seo, text: 'text', site: site, path: URI::encode("/tags/comrade")) }

    it 'has seo description' do
      expect(tag1.has_description?).to be_truthy
      expect(tag1.seo).to eq(seo)
      expect(tag1.seo.text).to eq('text')
    end

    it 'updates seo when updated' do
      tag1.link = 'friend'
      tag1.save
      expect(tag1.has_description?).to be_truthy
      expect(tag1.seo.text).to eq('text')
    end

  end

end