class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :path
      t.references :document, index: true

      t.timestamps
    end
  end
end
