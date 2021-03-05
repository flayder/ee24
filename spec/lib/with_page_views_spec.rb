require 'spec_helper'

class Foo < Struct.new(:page_views)
  include WithPageViews
  attr_writer :page_views

  def id
    @id ||= rand(100) + 1
  end
  
  def page_views
    self[:page_views] ||= 1
  end
end

# describe 'WithPageViews' do
#   let(:obj) { Foo.new }
#   subject { obj }

#   before { $page_views_redis.flushdb }

#   describe '#page_views_redis_key' do
#     its(:page_views_redis_key) { should eq("#{obj.class.name}:#{obj.id}") }
#   end

#   describe '#inc_page_views!' do
#     let(:obj) { Foo.new(100) }
    
#     before { obj.inc_page_views! obj.site }
    
#     it 'adds key to redis' do
#       $page_views_redis.exists(obj.page_views_redis_key).should be_true
#     end

#     it 'sets key value to page views plus one' do
#       $page_views_redis.get(obj.page_views_redis_key).should eq('101')
#     end

#     it 'increments key value if key exists' do
#       $page_views_redis.set obj.page_views_redis_key, 200
#       obj.inc_page_views! obj.site
#       $page_views_redis.get(obj.page_views_redis_key).should eq('201')
#     end
#   end

#   describe '#delete_page_views_redis_key' do
#     before do
#       obj.inc_page_views! obj.site
#     end

#     it 'deletes obj key' do
#       expect {
#         obj.delete_page_views_redis_key
#       }.to change { $page_views_redis.exists(obj.page_views_redis_key) }.from(true).to(false)
#     end
#   end
# end