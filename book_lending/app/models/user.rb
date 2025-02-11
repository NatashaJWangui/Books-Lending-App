class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :borrows, dependent: :destroy
  has_many :borrowed_books, through: :borrows, source: :book

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :name, presence: true
end
