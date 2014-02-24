class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.string :content
      t.references :user, index: true
      t.references :comment, index: true
      t.references :document, index: true

      t.timestamps
    end
  end
end
