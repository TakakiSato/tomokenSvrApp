class CreateCourseDetails < ActiveRecord::Migration
  def change
    create_table :course_details ,id: false do |t|
      t.integer :course_detail_id, :null => false
      t.references :course,:null => false
      t.decimal :latitude,  precision: 17, scale: 14,:null => false
      t.decimal :longitude, precision: 17, scale: 14,:null => false
      t.timestamps
    end
      add_index :course_details, [:course_detail_id, :course_id], unique: true, name: 'composit'
  end
end
