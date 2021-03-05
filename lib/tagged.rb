#encoding: utf-8
module Tagged
  def self.included(base)
    base.class_eval do
      acts_as_ordered_taggable
      before_validation :prepare_tags
      validate  :only_existing_tags

      def load_tags(tag_list)
        ActsAsTaggableOn::Tag.site(self.site).find_or_create_all_with_like_by_name(tag_list)
      end

      def only_existing_tags
        if self.site_id? && self.tag_list.present?
          existing_tags = self.site.tags.where(name: self.tag_list)
          if self.tag_list.size > existing_tags.count
            errors.add(:tag_list, ': пожалуйста, используйте только существующие')
            false
          else
            true
          end
        end
        true
      end

      #сразу убираю новые теги, в случае, если введён тег в другом регистре, сохраняем, как уже имеющийся тег
      def prepare_tags
        prepared_tag_list = []
        if self.site_id? && self.tag_list.present?
          self.tag_list.each do |tag_name|
            tag = self.site.tags.find_by_name(tag_name)
            if tag.present?
              prepared_tag_list.push(tag.name)
            end
          end
          self.tag_list = prepared_tag_list.join(', ')
        end
      end
    end
  end
end
