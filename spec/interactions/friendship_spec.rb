# encoding : utf-8
require 'spec_helper'

describe Friendship do
  let!(:user) { create :user }
  let!(:friend) { create :user, site: user.site } 
  let(:friendship) { Friendship.new user }

  describe '#add_friend' do
    before do
      friendship.add_friend friend.subdomain
    end

    it 'creates admin messages' do
      Message.all.count.should eq(2)
    end

    it 'creates friend approval' do
      user.friends_approve.count.should eq(1)
    end
  end

  describe '#approve_friend' do
    let(:message) { friend.admin_messages.last }

    before do
      friendship.add_friend friend.subdomain
      Friendship.new(friend).approve_friend message.id
    end

    it 'creates friend for user' do
      user.friends.count.should eq(1)
    end

    it 'creates friend for friend' do
      friend.friends.count.should eq(1)
    end

    it 'deletes friend approval' do
      user.friends_on_approve.should be_empty
    end
  end

  describe '#decline_friend' do
    let(:message) { friend.admin_messages.last }

    before do
      friendship.add_friend friend.subdomain
      Friendship.new(friend).decline_friend message.id
    end

    it 'does not create friend for user' do
      user.friends.count.should eq(0)
    end

    it 'does not create friend for friend' do
      friend.friends.count.should eq(0)
    end

    it 'deletes friend approval' do
      user.friends_on_approve.should be_empty
    end
  end

  describe '#delete_friend' do
    let(:message) { friend.admin_messages.last }

    before do
      friendship.add_friend friend.subdomain
      Friendship.new(friend).approve_friend message.id
      friendship.delete_friend friend
    end

    it 'deletes friendship' do
      user.friends.count.should eq(0)
      friend.friends.count.should eq(0)
    end
  end
end
