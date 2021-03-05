require 'spec_helper'
require 'carrierwave/test/matchers'

describe PhotoUploader do
  include CarrierWave::Test::Matchers
  let(:photo) { build :photo }

  before do
    PhotoUploader.enable_processing = true

    @uploader = PhotoUploader.new(photo, :image)
    @uploader.store!(fixture_file('ava.jpg'))
  end

  after do
    PhotoUploader.enable_processing = false
    @uploader.remove!
  end

  it 'should have model' do
    @uploader.model.should eq(photo)
  end
end