class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :borrows, dependent: :destroy
  has_many :borrowed_books, through: :borrows, source: :book

  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "is invalid" }
end
