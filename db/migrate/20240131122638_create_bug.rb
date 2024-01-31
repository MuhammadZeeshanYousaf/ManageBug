class CreateBug < ActiveRecord::Migration[7.0]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.datetime :deadline
      t.integer :bug_type
      t.integer :status
      t.integer :creator_id
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
  end
end
