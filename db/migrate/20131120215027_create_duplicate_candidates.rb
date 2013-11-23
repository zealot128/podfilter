class CreateDuplicateCandidates < ActiveRecord::Migration
  def change
    create_table :duplicate_candidates do |t|
      t.integer :ids, array: true
      t.string :md5
    end
    add_index :duplicate_candidates, :md5, unique: true
  end
end
