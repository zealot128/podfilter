class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.belongs_to :owner, index: true
      t.string :provider
      t.string :uid
      t.string :email
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
