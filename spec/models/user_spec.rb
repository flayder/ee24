# encoding : utf-8
require 'spec_helper'

describe User do
  let(:user) { create :user }
  subject { user }
  before(:each) do
    # do not even try to send e-mails
    User.any_instance.stub(:deliver_confirm).and_return(nil)
  end

  it { should be_valid }
  it { should belong_to(:site) }

  it 'should not create user with incorrect email' do
    u = build(:user, :email => " email with spaces@dome.infO\r\n")
    u.save.should be_falsey
    u.errors[:email].size.should eq(1)
  end

  describe '#set_subdomain' do
    it 'should create subdomain for user with simular logins' do
      ['olyala', 'оляла', 'оляla'].each_with_index do |login, index|
        user = create(:user, :login => login)

        if index > 0
          user.subdomain.should == "olyala#{index}"
        end
      end
    end

    it 'should replace non-letter symbols with dash' do
      user = create(:user, :login => 'Привет222, я"юзер""')
      user.subdomain.should == Russian.translit('привет222--я-юзер')
    end
  end

  describe '#generate_confirmation_token' do
    it 'should save user after generating token' do
      user = build(:user)
      user.update_confirmation_token
      user.should be_persisted
    end
  end

  describe 'friendship' do
    let(:user) { create :user }
    let(:friend) { create :user }

    context 'approves' do
      before do
        user.friends_approve << friend
      end

      it 'should be able to ask for approve' do
        user.friends_approve.count.should eq(1)
      end

      it 'should not be able to ask for approve twice' do
        expect{ user.friends_approve << friend }.to raise_error(
          ActiveRecord::RecordNotUnique
        )
      end
    end

    context 'friends' do
      before do
        user.friends << friend
      end

      it 'should be able to add friend' do
        user.friends.count.should eq(1)
      end

      it 'should not be able to add friend twice' do
        expect{ user.friends << friend }.to raise_error(
          ActiveRecord::RecordNotUnique
        )
      end
    end

  end

  describe '#fio' do
    let(:user) { create :user, :first_name => 'Anatoli', :last_name => 'Makarevich' }

    it 'should return last name and first name together' do
      user.fio.should eq('Anatoli Makarevich')
    end
  end

  describe '#fio_or_login' do
    let(:user) { create :user, :first_name => nil, :last_name => nil }

    it 'should return login if fio is empty' do
      user.fio_or_login.should eq(user.login)
    end
  end

  describe '#ban!' do
    it 'should set ban to true' do
      user.ban!
      user.ban?.should be_truthy
    end
  end

  describe '#send_new_message_notification' do
    before { ResqueSpec.reset! }

    context 'when email notifications are on' do
      it 'does receive email' do
        user.send_new_message_notification(user.site)
        Mailer.should have_queue_size_of(1)
      end
    end

    context 'when email notifications are off' do
      let(:user) { create :user, :email_notification => false }

      before do
        user.send_new_message_notification(user.site)
      end

      it 'does not receive email' do
        Mailer.should have_queue_size_of(0)
      end
    end
  end


  describe 'restore_password!' do
    before do
      user.stub(:generate_password).and_return('qweqwe')
    end

    it 'returns new password for user' do
      user.restore_password!.should eq('qweqwe')
    end

    it 'sets new password' do
      user.restore_password!
      user.authenticated?('qweqwe').should be_truthy
    end
  end
end
