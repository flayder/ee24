# encoding : utf-8
require 'spec_helper'

describe UserCreator do
  describe '.create_from_session' do
    let(:site) { create :site }

    it 'should create user from session' do
      data = { 'info' =>
          {
            'email' => 'some@mail.pr',
            'password' => 'somepass',
            'nickname' => 'some_nickname'
          }
        }

      user = UserCreator.create_from_session(data, site)
      user.should be_persisted
      user.login.should eq('some_nickname')
    end

    it 'should not create user from session if data is invalid' do
      skip '****** FIX ME ******'
      # now UserCreator use in omniauth, where user can be saved without email (for example from vk)

      data = { 'info' =>
        {
          'email' => '',
          'password' => 'somepass',
          'nickname' => 'some_nickname'
        }
      }

      user = UserCreator.create_from_session(data, site)
      user.should_not be_persisted
    end
  end
end

