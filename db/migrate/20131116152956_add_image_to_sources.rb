class AddImageToSources < ActiveRecord::Migration
  def change
    add_column :sources, :image, :string
  end
end
