# encoding : utf-8
require 'spec_helper'

describe Gallery do
  let(:first_rubric) { create :photo_rubric }

  let(:gallery) { create :gallery, :photo_rubric => first_rubric }
  subject { gallery }

  it { should be_valid }

  it_behaves_like 'with moderation notification sending' do
    let(:model) { :gallery }
  end

  it_behaves_like 'approvable' do
    let(:obj) { gallery }
  end

end
