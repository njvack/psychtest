class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.references :assessment
      t.integer :unique_id, :null => false
      t.string :category, :null => false
      t.float :value, :null => false, :limit => 53
      t.index [:assessment_id, :unique_id], :name => :index_measurements_on_assessment_id_and_unique_id, :unique => true
      t.timestamps
    end
  end
end
