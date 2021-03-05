# encoding : utf-8
require 'spec_helper'

describe ApplicationHelper do
  fixtures :all

  describe "default_avatar_path" do
    let(:user) { create(:user_with_avatar) }

    it "should form url for avatars considering gender" do
      user.stub(:gender){ 'female' }

      path = default_avatar_path(user, 'small')
      path.should match(/\/no_avatar_female_/)

      user.stub(:gender){ 'male' }
      path = default_avatar_path(user, 'small')
      path.should match(/\/no_avatar_male_/)

      user.stub(:gender){ 'not_set' }
      path = default_avatar_path(user, 'small')
      path.should match(/not_set_/)
    end

    it "should form url considering size" do
      user.stub(:gender){ 'not_set' }

      small_image_path = default_avatar_path(user, "small")
      small_image_path.should match(/_50\.jpg$/)

      other_image_path = default_avatar_path(user, "other")
      other_image_path.should match(/_100\.jpg$/)
    end
  end

  describe "avatar_url" do
    let(:user) { create(:user_with_avatar) }

    before(:each) do
      @city = City.new
    end

    it "should return user avatar url if user has an avatar" do
      url = avatar_url(user, "small")
      url.should == "/system/user/avatar/#{user.avatar.get_last_dir_part user.id}/small/ava.jpg"
    end

    it "should set default size value to avatar" do
      url = avatar_url(user)
      url.should == "/system/user/avatar/#{user.avatar.get_last_dir_part user.id}/avatar/ava.jpg"
    end

    it "should return url to default avatar when user avatar is not set" do
      user.stub(:avatar?) { false }
      url = avatar_url(user)
      url.should == "/assets/user_icon/no_avatar_not_set_100.jpg"
    end
  end

end
