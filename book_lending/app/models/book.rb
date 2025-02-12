class Book < ApplicationRecord
  has_many :borrows, dependent: :destroy
  has_many :users, through: :borrows

  def available?
    !borrows.exists?(returned_at: nil) 
  end
end
