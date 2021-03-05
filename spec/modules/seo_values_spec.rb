require 'spec_helper'

describe SeoValues do
  # we use RubricDoc since it includes SeoValues
  let(:seo) { create :seo }
  let(:object) { seo.seo }
  
  it 'should return meta title' do
    object.meta_title(seo.site).should eq(seo.title)
  end

  it 'should return about' do
    object.seo_sub_text(seo.site).should eq(seo.sub_text)
  end

  it 'should return about' do
    object.seo_about(seo.site).should eq(seo.about)
  end

  it 'should return seo_text' do
    object.seo_text(seo.site).should eq(seo.text)
  end

  it 'should return description' do
    object.meta_description(seo.site).should eq(seo.description)
  end

  it 'should return keywords' do
    object.meta_keywords(seo.site).should eq(seo.keywords)
  end

  it 'should return seo itself' do
    object.seo(seo.site).should eq(seo)
  end
end