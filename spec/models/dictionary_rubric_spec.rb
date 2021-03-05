# encoding : utf-8
require 'spec_helper'

describe DictionaryRubric do
  let(:dictionary_rubric) { create :dictionary_rubric }
  subject { dictionary_rubric }
  
  it { should be_valid }
  it { should belong_to(:site) }
  it { should belong_to(:dictionary) }
  it { should have_many(:objects).dependent(:destroy) }
  it { should validate_presence_of(:title) }
end
