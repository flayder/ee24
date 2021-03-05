# encoding : utf-8
require 'spec_helper'

def old_to_param doc, field
  "#{doc.send(field)}-#{doc.param}"
end

describe MigratedDocFinder do
  describe '.find_doc' do
    context 'when double migrated docs (with news_doc_doc_id and news_doc_id)' do
      context 'with news_doc_doc_id' do
        let!(:doc) { create :double_migrated_doc }

        it 'finds double migrated doc' do
          found_doc = MigratedDocFinder.find_doc(doc.rubric, old_to_param(doc, :news_doc_doc_id))
          found_doc.should eq(doc)
        end
      end

      context 'with news_doc_id' do
        let!(:doc) { create :double_migrated_doc }

        it 'finds double migrated doc' do
          found_doc = MigratedDocFinder.find_doc(doc.rubric, old_to_param(doc, :news_doc_id))
          found_doc.should eq(doc)
        end
      end
    end

    context 'migrated docs (with news_doc_id)' do
      let!(:doc) { create :migrated_once_doc }

      it 'finds migrated once doc' do
        found_doc = MigratedDocFinder.find_doc(doc.rubric, old_to_param(doc, :news_doc_id))
        found_doc.should eq(doc)
      end
    end
  end
end
