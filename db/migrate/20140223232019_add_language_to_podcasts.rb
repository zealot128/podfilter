class AddLanguageToPodcasts < ActiveRecord::Migration
  def change
    add_column :podcasts, :language, :string
  end
end
