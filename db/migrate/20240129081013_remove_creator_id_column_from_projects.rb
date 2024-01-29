class RemoveCreatorIdColumnFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :creator_id
  end

  def revert
    add_column :projects, :creator_id, :integer
  end
end
