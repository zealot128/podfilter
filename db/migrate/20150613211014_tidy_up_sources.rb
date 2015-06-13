class TidyUpSources < ActiveRecord::Migration
  def change
    change_table :sources do |t|
      t.remove :title
      t.remove :description
      t.remove :ancestry
      t.remove :redirected
    end
  end
end
