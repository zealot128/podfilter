class AddApiKeyToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :api_key, :string
    add_index :owners, :api_key, unique: true
  end
end
