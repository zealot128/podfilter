class AddRedirectedToToSources < ActiveRecord::Migration
  def change
    add_reference :sources, :redirected_to, index: true
  end
end
