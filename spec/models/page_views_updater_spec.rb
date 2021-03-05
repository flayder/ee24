require 'spec_helper'

describe PageViewsUpdater do
  let!(:doc) { create :doc }
  let(:keys) { [doc].map(&:page_views_redis_key) }

  describe '.update' do
    before do
      ResqueSpec.reset!
      $page_views_redis.flushdb
      keys.each { |key| $page_views_redis.set key, 10 }
      PageViewsUpdater.update(keys)
    end

    it 'updates page_views in mysql' do
      doc.reload.page_views.should eq(10)
    end

    it 'deletes keys from redis' do
      $page_views_redis.keys.should be_empty
    end

    it 'deletes key if there is no record' do
      invalid_key = 'Doc:100500'
      $page_views_redis.set invalid_key, 100500
      PageViewsUpdater.update [invalid_key]
      $page_views_redis.keys.should be_empty
    end
  end
end
