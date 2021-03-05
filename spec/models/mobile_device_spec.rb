# encoding : utf-8
require 'spec_helper'

describe MobileDevice do
  let!(:site) { create :site}
  let!(:mobile_device) { create :mobile_device, site: site }
  subject { mobile_device }

  it { should be_valid }
end
