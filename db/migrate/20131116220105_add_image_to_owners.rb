class AddImageToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :image, :string
  end
end
