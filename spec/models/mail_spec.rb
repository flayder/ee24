# encoding : utf-8
require 'spec_helper'

describe "confirmation email" do

  pending 'Should be moved to mailers i.e. UserMailer'

  # before(:all) do
  #   login = "tester"
  #   email = "tester@example.org"
  #   token = "12345-token"
  #   password = "12345"
  #   sent_at = Time.at(0)
  # 
  #   @email = Mail.confirm(login, email, token, password, sent_at)
  # end
  # 
  # it "should deliver email to the address passed as email" do
  #   @email.header["to"].body.should == "tester@example.org"
  # end
  # 
  # it "should deliver from info@36on.ru" do
  #   @email.header["from"].body.should == "\"36on.ru\" <info@36on.ru>"
  # end
  # 
  # it "should have return-path header set to info email" do
  #   @email.header["return-path"].body.should == "<info@36on.ru>"
  # end
  # 
  # it "should have correct subject encoded to base64" do
  #   subject = @email.header["subject"].body
  #   #subject.gsub!(/=\?utf-8\?B\?(.*)=\?=/, '\1')
  #   decoded_sujbect = Base64.decode64(subject)
  #   decoded_sujbect.should == "36on.ru: подтверждение регистрации"
  # end
  # 
  # def find_all(array)
  #   return nil unless block_given?
  #   array = array.collect do |element|
  #     element if yield(element)
  #   end
  # 
  #   return array.compact()
  # end

  #TODO Придумать как тестировать картинку в письме
#  it "should have logo attachment of the image/gif type" do
#    logo_attachments = find_all(@email.attachments) do |attachment|
#      attachment if attachment.original_filename == "logo.gif"
#    end
#    logo_attachments.length.should == 1
#
#    logo = logo_attachments.first
#    logo.content_type.should == "image/gif"
#  end
#
#  it "it should have and attachment part with the corresponding content-id" do
#    logo_parts = find_all(@email.parts) do |part|
#      cid = part.header["content-id"]
#      cid && cid.body == "<0.0logo.png@127.0.0.1:3000>"
#    end
#
#    logo_parts.length.should == 1
#  end
#
#  it "should have logo attachment referenced from the email via cid" do
#    @email.body.should match("<img src='cid:0.0logo.png@127.0.0.1:3000' height='44px'>")
#  end
end
