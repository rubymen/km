class CreateDocumentsUsers < ActiveRecord::Migration
  def change
    create_table :documents_users do |t|
      t.references :document, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
