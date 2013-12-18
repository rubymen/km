class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :state
      t.string :title
      t.text :content
      t.text :description

      t.timestamps
    end
  end
end
