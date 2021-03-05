class AddParamToCatalogsAndRubrics < ActiveRecord::Migration
  def self.up
    add_column :catalog2s, :param, :string
    add_column :catalog_global_rubrics, :param, :string
  end

  def self.down
    remove_column :catalog_global_rubrics, :param
    remove_column :catalog2s, :param
  end
end
