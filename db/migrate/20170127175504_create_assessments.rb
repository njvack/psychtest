# This is a pure placeholder table for now. Later it'll at least link to
# participant.
class CreateAssessments < ActiveRecord::Migration[5.0]
  def change
    create_table :assessments do |t|
      t.timestamps
    end
  end
end
