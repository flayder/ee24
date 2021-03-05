# encoding : utf-8
require 'spec_helper'

describe AdSurface do
  let(:site) { create :site }
  let(:city) { site.city }
  let(:ad_surface)  { create :ad_surface, :city => city }

  subject { ad_surface }
  
  it { should be_valid }
  # REFACTOR to has_one(:street) smth like this
  its(:street) { should be_persisted }

  # REFACTOR how to test private method properly?
  describe '#set_street' do
    let(:street) { create(:street, :title => 'ул. Ленина', :city => city) }
    let!(:ad_surface){ create(:ad_surface, :street_title => 'ул. Ленина', :city => city) }
  
    it 'should create street when creating ad surface' do
      ad_surface.street.title.should == 'ул. Ленина'
    end
  
    it 'should not create duplicate street when creating ad surface' do
      Street.find_all_by_title('ул. Ленина').count.should == 1
    end
  end
end
