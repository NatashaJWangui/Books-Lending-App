class Book < ApplicationRecord
  has_many :borrows, dependent: :destroy
  has_many :users, through: :borrows

  validates :title, presence: { message: "cannot be blank" }
  validates :author, presence: { message: "cannot be blank" }
  validates :isbn, presence: { message: "cannot be blank" }, uniqueness: { message: "must be unique" }

  def available?
    !borrows.exists?(returned_at: nil) 
  end
end
