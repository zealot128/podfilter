class AnonymizeIdentities < ActiveRecord::Migration
  def change
    Identity.update_all name: '***', email: nil
    Identity.where('image is not null').find_each do |i|
      i.image.remove!
    end
  end
end
