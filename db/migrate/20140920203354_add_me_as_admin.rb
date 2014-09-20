class AddMeAsAdmin < ActiveRecord::Migration
  def change
    Owner.where(id: Identity.where(name: 'Stefan Wienert').pluck(:owner_id).uniq).update_all admin: true
  end
end
