# encoding : utf-8
module SubjectEncoder
  require 'base64'
  private
  
  def encode_subj(subj)
  	"=?utf-8?B?"+Base64.encode64(subj)+"=?="
  end
end
