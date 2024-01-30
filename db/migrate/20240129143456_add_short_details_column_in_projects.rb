class AddShortDetailsColumnInProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :details, :text
  end
end
