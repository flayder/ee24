# encoding : utf-8
require 'spec_helper'

describe DictionaryObject do
  let(:dictionary_object) { create :dictionary_object }
  subject { dictionary_object }
  
  it { should be_valid }
  it { should belong_to(:site) }
  it { should belong_to(:rubric) }
end
