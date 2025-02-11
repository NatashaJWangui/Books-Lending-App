class Book < ApplicationRecord
  has_many :borrows, dependent: :destroy
  has_many :users, through: :borrows

  def available?
    borrows.where(returned_at: nil).empty?
  end
end
