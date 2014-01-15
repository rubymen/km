class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :document, index: true
      t.string :slug, :string, unique: true
      t.string :title

      t.timestamps
    end
  end
end
