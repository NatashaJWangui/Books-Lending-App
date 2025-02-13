require "test_helper"

class BorrowTest < ActiveSupport::TestCase
  setup do
    @user = User.create(email: "user@example.com", password: "password")
    @book = Book.create(title: "Sample Book", author: "Sample Author", isbn: "123456789")
  end

  test "should create a valid borrow record" do
    borrow = Borrow.new(user: @user, book: @book, due_date: 2.weeks.from_now)
    assert borrow.save, "Failed to save a valid borrow record"
  end

  test "should not allow borrowing the same book twice" do
    Borrow.create(user: @user, book: @book, due_date: 2.weeks.from_now)
    duplicate_borrow = Borrow.new(user: @user, book: @book, due_date: 2.weeks.from_now)
    
    assert_not duplicate_borrow.save, "Allowed borrowing a book that is already borrowed"
  end

  test "should require a user" do
    borrow = Borrow.new(book: @book, due_date: 2.weeks.from_now)
    assert_not borrow.save, "Saved borrow without a user"
  end

  test "should require a book" do
    borrow = Borrow.new(user: @user, due_date: 2.weeks.from_now)
    assert_not borrow.save, "Saved borrow without a book"
  end
end
