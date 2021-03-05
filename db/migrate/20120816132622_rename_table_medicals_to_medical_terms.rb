class RenameTableMedicalsToMedicalTerms < ActiveRecord::Migration
  def change
    rename_table 'medicals', 'medical_terms'
  end
end
