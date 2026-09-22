class RenameProjectsToGuides < ActiveRecord::Migration[8.1]
  def change
    rename_table :projects, :guides

    remove_column :guides, :project_link, :string
    remove_column :guides, :repo_link, :string
    remove_column :guides, :tech_stack, :string
    remove_column :guides, :position, :integer, default: 0, null: false

    add_column :guides, :slug, :string
    add_column :guides, :published, :boolean, default: false, null: false
    add_column :guides, :published_at, :datetime

    add_index :guides, :slug, unique: true
    add_index :guides, :published_at
  end
end
