# encoding : utf-8
require 'spec_helper'

describe Catalog do
  let(:catalog) { create :catalog }
  subject { catalog }

  it { should be_valid }

  it {
    skip '********** NEED REFACTORING *********'
    should validate_presence_of(:title).with_message(/Вы не указали наименование организации/)
  }
  it {
    should validate_presence_of(:street_address).
    with_message(/Вы не указали адрес/)
  }
  it {
    should validate_presence_of(:tel).
    with_message(/Вы не указали телефон/)
  }
  it {
    catalog.site.city = nil # locality be default if city title
    should validate_presence_of(:locality).
    with_message(/Вы не указали населенный пункт/)
  }
  it { should validate_presence_of(:site_id) }

  it {
    skip '********** NEED REFACTORING *********'
    should validate_presence_of(:catalog_rubric_id).
    with_message(/Необходимо указать рубрику/)
  }

  it_behaves_like 'with moderation notification sending' do
    let(:model) { :catalog }
  end

  it_behaves_like 'approvable' do
    let(:obj) { catalog }
  end

  describe '#geocode' do
    it 'should be called when save catalog for site with yandex map provider' do
      catalog.should_receive(:geocode)
      catalog.save
    end

    it 'should be called when save catalog for site with yandex map provider' do
      catalog.site.update_attribute(:map_provider, 'google')

      catalog.should_not_receive(:geocode)
      catalog.save
    end
  end

  describe "#address" do
    before { skip("***** SKIP BCZ THE OLD CODE *****") }

    let(:city) do
      create(
        :city,
        :title => "Воронеж",
        :region => "Воронежская область"
      )
    end
    let(:site) { create(:site, :city => city) }
    let(:catalog) do
      create(
        :catalog,
        :region_extension => "Семилукский р-н",
        :locality => "дер. Коршуново",
        :street_address => "ул. Байкова, д. 1",
        :hcard_converted => true,
        :site => site
      )
    end

    it "should return full address string for full hcard_converted address" do
      catalog.address.should eql("Воронежская область, Семилукский р-н, дер. Коршуново, ул. Байкова, д. 1")
    end

    it "should return correct address string for partialy filled hcard_converted address" do
      catalog.region_extension = ""
      catalog.street_address = ""
      catalog.address.should eql("Воронежская область, дер. Коршуново")
    end

    it "should return old formatted address string for not hcard_converted address" do
      catalog.hcard_converted = false
      catalog.address = "Колыма, г. Богульск, д. 3А"
      catalog.address.should eql("Колыма, г. Богульск, д. 3А")
    end
  end

  context 'when assign rubrics' do
    let!(:rubric) { create :catalog_rubric }
    let!(:site) { catalog.site }

    before :each do
      catalog.rubrics << rubric
    end

    context 'when approved changed' do
      it 'calls update_rubrics_counter' do
        catalog.should_receive(:update_rubrics_counter)
        catalog.toggle(:approved).save
      end
    end
  end

  describe '#locality' do
    it 'should return site city title if locality is not set' do
      catalog.locality = nil
      catalog.locality.should eq(catalog.city.title)
    end

    it 'should return locality if set' do
      catalog.locality = 'Somewhere'
      catalog.locality.should eq('Somewhere')
    end
  end
end
