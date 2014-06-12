class CreateChangeRequests < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    create_table :change_requests do |t|
      t.string :type
      t.boolean :completed
      t.belongs_to :owner, index: true
      t.hstore :payload
      t.string :token

      t.timestamps
    end
    add_index :change_requests, :type
    add_index :change_requests, :token
    add_index :change_requests, :completed
  end
end
