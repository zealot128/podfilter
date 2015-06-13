class AddRedirectedToSources < ActiveRecord::Migration
  def change
    add_column :sources, :redirected, :boolean
  end
end
