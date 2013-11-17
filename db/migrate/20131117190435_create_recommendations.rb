class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.belongs_to :owner
      t.belongs_to :source
      t.integer :weight
    end
    add_index :recommendations, :weight
    add_index :recommendations, [:owner_id, :source_id], unique: true, name: 'recommendations_owner_source'
  end
end
