class AddStatusToOrderitems < ActiveRecord::Migration
  def change
    add_column :orderitems, :status, :string
  end
end
