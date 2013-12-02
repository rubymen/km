class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :avatar
      t.string :birthdate
      t.string :country_code
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :street
      t.string :town

      t.timestamps
    end
  end
end
