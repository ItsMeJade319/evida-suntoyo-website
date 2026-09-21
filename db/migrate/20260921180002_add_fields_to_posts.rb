class AddFieldsToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :title, :string
    add_column :posts, :slug, :string
    add_column :posts, :body, :text
    add_column :posts, :published, :boolean, null: false, default: false
    add_column :posts, :published_at, :datetime

    add_index :posts, :slug, unique: true
    add_index :posts, :published_at
  end
end
