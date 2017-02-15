# This contains the stuff associated with an assessment.
class CreateAssessments < ActiveRecord::Migration[5.0]
  def change
    create_table :assessments do |t|
      t.string :user_agent
      t.boolean :completed, :default => false, :null => false
      t.jsonb :configuration
      t.timestamps
    end
  end
end
