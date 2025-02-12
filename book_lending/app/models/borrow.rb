class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book
  
  validates :borrowed_at, :due_date, presence: true
  validate :book_must_be_available, on: :create
  validate :user_cannot_borrow_same_book_twice, on: :create
  validate :user_must_return_previous_books, on: :create 

  before_validation :set_dates, on: :create

  private

  def set_dates
    self.borrowed_at ||= Time.current
    self.due_date ||= 2.weeks.from_now
  end

  def book_must_be_available
    errors.add(:book, "is already borrowed") unless book.available?
  end

  def overdue?
    due_date < Time.zone.now && returned_at.nil?
  end 
  
  def user_cannot_borrow_same_book_twice
    if user.borrows.where(book: book, returned_at: nil).exists?
      errors.add(:book, "has already been borrowed and not returned yet.")
    end
  end
  
  def user_must_return_previous_books
    if user.borrows.where(returned_at: nil).exists?
      errors.add(:base, "You must return your current book before borrowing a new one.")
    end
  end
end
