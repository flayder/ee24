require 'spec_helper'

describe Linker do
  let(:linker) { create :linker }
  subject { linker }

  it { should be_valid }
end
