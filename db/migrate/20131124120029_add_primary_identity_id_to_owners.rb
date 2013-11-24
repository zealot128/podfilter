class AddPrimaryIdentityIdToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :primary_identity_id, :integer
    add_index :owners, :primary_identity_id
  end
end
