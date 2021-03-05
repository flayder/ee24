# encoding: utf-8
RSpec.configure do |config|
  config.before(:each) do
    PaperTrail.enabled = false
    #PaperTrail.controller_info = {}
    #PaperTrail.whodunnit = nil
  end
 
  config.before(:each, :versioning => true) do
    PaperTrail.enabled = true
  end
end
