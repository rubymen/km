class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :avatar
      t.string :phone
      t.string :birthdate
      t.string :town
      t.string :street
      t.string :country_code

      t.timestamps
    end
  end
end
