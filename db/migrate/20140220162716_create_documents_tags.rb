class CreateDocumentsTags < ActiveRecord::Migration
  def change
    create_table :documents_tags do |t|
      t.references :document, index: true
      t.references :tag, index: true

      t.timestamps
    end

    remove_column :tags, :document_id
  end
end
