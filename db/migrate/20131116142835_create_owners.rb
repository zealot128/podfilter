class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :token

      t.timestamps
    end
    add_index :owners, :token, unique: true
  end
end
