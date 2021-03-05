# encoding : utf-8
require 'spec_helper'

describe CleanWeb::Checker do
  let(:checker) { CleanWeb::Checker.new }
  let(:xml_response) { fixture_file 'yandex_cleanweb.xml' }
  
  describe '#check' do
    context 'when no spam' do
      before do
        CleanWeb::Checker.any_instance.stub(:get_response).and_return double(:response => xml_response, :code => '200')
      end

      it 'returns false' do
        checker.check('title', 'body').should be_falsey
      end
    end
  end
end