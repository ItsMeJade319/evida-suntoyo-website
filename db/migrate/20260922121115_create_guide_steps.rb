class CreateGuideSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :guide_steps do |t|
      t.references :guide, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :guide_steps, [ :guide_id, :position ]
  end
end
