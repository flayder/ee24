require 'spec_helper'

describe MainMenuLink do
  let(:link) { create :main_menu_link }
  subject { link }

  it { should be_valid }

  context 'url or path' do
    let(:link) { build :main_menu_link, path: 'http://yandex.ru/' }

    it { should be_valid }

    context 'invalid' do
      let(:link) { build :main_menu_link, path: 'wrong_path' }

      it { should_not be_valid }
    end
  end
end
