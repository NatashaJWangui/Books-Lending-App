class ChangeReturnedAtInBorrows < ActiveRecord::Migration[7.0]
  def change
    remove_column :borrows, :returned_at
    add_column :borrows, :returned_at, :datetime
  end
end
