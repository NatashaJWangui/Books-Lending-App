class RenameReturnedToReturnedAtInBorrows < ActiveRecord::Migration[7.0]
  def change
    rename_column :borrows, :returned, :returned_at
  end
end
