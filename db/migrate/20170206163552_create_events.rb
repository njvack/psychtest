class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :assessment
      t.integer :unique_id, :null => false
      t.integer :relative_timestamp, :null => false
      t.jsonb :event_json, :null => false
      t.index [:assessment_id, :unique_id], :name => :index_events_on_assessment_id_and_unique_id, :unique => true
      t.index :event_json, :using => :gin
      t.timestamps
    end
  end
end
