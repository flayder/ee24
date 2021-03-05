# encoding: utf-8
require 'spec_helper'

def should_assign_defaults
  it 'assigns @dictionary' do
    assigns(:dictionary).should eq(dictionary)
  end
end

describe DictionaryObjectsController do

  let!(:dictionary) { create :dictionary, :site => @site }
  let!(:dictionary_rubric) { create :dictionary_rubric, :dictionary => dictionary, :site => @site }
  let!(:dictionary_object) { create :dictionary_object, :approved, :rubric => dictionary_rubric, :site => @site }
  let!(:dictionary_section) { create :section, :controller => 'dictionary_objects' }
  let!(:dictionary_site_section) { create :site_section, :section => dictionary_section, :site => @site}

  before(:each) do
    @request.host = @site.domain
    ['persona', 'attractions', 'czech_beer', 'medical'].each { |e| create :dictionary, site: @site, link: e }
  end

  describe 'GET index' do
    before :each do
      get :index, :link => dictionary.link
    end

    should_assign_defaults

    it 'assigns @dictionary_objects' do
      assigns(:dictionary_objects).should eq([dictionary_object])
    end

    it 'renders the index template' do
      response.should be_success
      response.should render_template('dictionary_objects/index')
    end
  end

  describe 'GET show' do
    before :each do
      get :show, :link => dictionary.link, :id => dictionary_object.id
    end

    should_assign_defaults

    it 'assigns @dictionary_object' do
      assigns(:dictionary_object).should eq(dictionary_object)
    end

    it 'renders the show template' do
      response.should be_success
      response.should render_template('dictionary_objects/show')
    end
  end

  describe 'GET letter' do
    before :each do
      get :letter, :link => dictionary.link, :letter => dictionary_object.letter
    end

    should_assign_defaults

    it 'assigns @dictionary_objects' do
      assigns(:dictionary_objects).should eq([dictionary_object])
    end

    it 'renders the show template' do
      response.should be_success
      response.should render_template('dictionary_objects/index')
    end
  end

  describe 'GET rubric' do
    before :each do
      get :rubric, :link => dictionary.link, :id => dictionary_rubric.id
    end

    should_assign_defaults

    it 'assigns @rubric' do
      assigns(:rubric).should eq(dictionary_rubric)
    end

    it 'renders the rubric template' do
      response.should be_success
      response.should render_template('dictionary_objects/rubric')
    end
  end

  describe 'ad_codes' do
    let!(:site_ad_code) { create :ad_code, :ad_section => @site, :banner_type => 'horizontal_top', :site => @site }
    let!(:ad_code) { create :ad_code, :ad_section => dictionary_site_section, :banner_type => 'horizontal_top', :site => @site }
    let!(:dictionary_ad_code) { create :ad_code, :ad_section => dictionary, :banner_type => 'horizontal_top', :site => @site }
    let!(:rubric_ad_code) { create :ad_code, :ad_section => dictionary_rubric, :banner_type => 'horizontal_top', :site => @site }

    it 'should display right ad code on dictionary page' do
      get :index, :link => dictionary.link
      assigns(:ad_codes)[:horizontal_top].should have_content(dictionary_ad_code.code)
    end

    it 'should display right ad code on rubric page' do
      get :rubric, :link => dictionary.link, :id => dictionary_rubric.id
      assigns(:ad_codes)[:horizontal_top].should have_content(rubric_ad_code.code)
    end

    it 'should display right ad code on letter page' do
      get :letter, :link => dictionary.link, :letter => 'А'
      assigns(:ad_codes)[:horizontal_top].should have_content(dictionary_ad_code.code)
    end

    it 'should display right ad code on "word" page' do
      get :show, :link => dictionary.link, :id => dictionary_object.id
      assigns(:ad_codes)[:horizontal_top].should have_content(rubric_ad_code.code)
    end
  end
end
