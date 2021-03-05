class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    change_table :tags do |t|
      t.remove :kind
    end

    change_table :taggings do |t|
      t.references :tagger, :polymorphic => true
      t.string :context
      t.datetime :created_at
    end

    ActsAsTaggableOn::Tagging.all.each do |tagging|
      tagging.created_at = Time.now
      tagging.context = 'tags'
      tagging.save
    end
  end

  def self.down
    change_table :tags do |t|
      t.string :kind
    end

    change_table :taggings do |t|
      t.remove :tagger_id
      t.remove :tagger_type

      t.remove :created_at
    end
  end
end
