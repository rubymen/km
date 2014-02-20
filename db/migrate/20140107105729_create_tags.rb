class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :document, index: true
      t.string :slug
      t.string :title

      t.timestamps
    end

    add_index :tags, :slug, unique: true
  end
end
