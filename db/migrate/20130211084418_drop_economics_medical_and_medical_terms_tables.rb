class DropEconomicsMedicalAndMedicalTermsTables < ActiveRecord::Migration
  def change
    drop_table :economics
    drop_table :medical_terms
  end
end
