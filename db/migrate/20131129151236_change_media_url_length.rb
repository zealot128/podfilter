class ChangeMediaUrlLength < ActiveRecord::Migration
  def change
    change_column :episodes, :media_url, :string, length: 512
  end
end
