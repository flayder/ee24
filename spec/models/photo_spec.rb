# encoding : utf-8
require 'spec_helper'

describe Photo do
  let(:photo) { create :doc_photo }

  subject { photo }

  it { should be_valid }
  it { should_not be_watermarked }

  describe 'processing image', trunc: true do
    let(:photo) { build :gallery_photo, :photo => create(:gallery) }

    before(:each) do
      Photo.any_instance.stub(:place_watermark_async).and_return(true)
      photo.image = fixture_file('ava.jpg')
    end

    it 'should need a watermark' do
      photo.need_watermark?.should be_truthy
    end

    it 'should have photo uploader' do
      photo.image.model.should eq(photo)
    end

    it 'should place watermark' do
      photo.should_receive(:place_watermark_async)
      photo.save
    end
  end

  describe 'place_watermark!' do
    before do
      photo.image.stub(:recreate_versions!)
      photo.stub(:need_watermark?).and_return(true)
      photo.place_watermark!
    end

    it 'should mark photo as watermarked' do
      photo.should be_watermarked
    end
  end

  describe 'delayed photo processing', trunc: true do
    let(:photo) { build :photo }

    before do
      ResqueSpec.reset!
      photo.image = fixture_file('ava.jpg')
    end

    it 'queues processing after create' do
      photo.should_receive :enqueue_image_background_job
      photo.save
    end
  end
end
