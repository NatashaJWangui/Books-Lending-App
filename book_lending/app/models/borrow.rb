class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book
  
  validates :borrowed_at, :due_date, presence: true
  validate :book_must_be_available, on: :create

  before_validation :set_dates, on: :create

  private

  def set_dates
    self.borrowed_at ||= Time.current
    self.due_date ||= 2.weeks.from_now
  end

  def book_must_be_available
    errors.add(:book, "is already borrowed") unless book.available?
  end
end
