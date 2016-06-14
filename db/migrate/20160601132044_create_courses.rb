class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses ,id: false do |t|
      t.column :course_id, 'INTEGER PRIMARY KEY AUTO_INCREMENT'
      t.references :user
      t.string :course_name
      t.timestamps
    end
  end
end
