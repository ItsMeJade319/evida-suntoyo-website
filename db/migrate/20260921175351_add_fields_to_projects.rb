class AddFieldsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :title, :string
    add_column :projects, :description, :text
    add_column :projects, :tech_stack, :string
    add_column :projects, :project_link, :string
    add_column :projects, :repo_link, :string
    add_column :projects, :position, :integer, null: false, default: 0

    add_index :projects, :position
  end
end
