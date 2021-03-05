# encoding: utf-8
require 'spec_helper'

describe ExternalDoc do
  let!(:doc) { create :external_doc }
  subject { doc }

  it { should be_valid }
  it { should allow_value('http://36on.ru/search').for(:url) }
  it { should_not allow_value('wrong_format').for(:url) }

  context 'when approved' do
    let!(:doc) { create :external_doc, :approved }
    subject { doc }

    it { should be_valid }
    its(:approved_at) { should be_kind_of(Time) }
  end
end
