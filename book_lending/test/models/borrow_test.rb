require "test_helper"

class BorrowTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "Alice", email: "alice@example.com", password: "password123")
    @book = Book.create!(title: "The Rainmaker", author: "John Grisham", isbn: "978-0385339605")
  end

  test "should create a borrow record with valid attributes" do
    borrow = Borrow.new(user: @user, book: @book)
    assert borrow.save, "Borrow record should be valid"
    assert_not_nil borrow.borrowed_at, "Borrowed date should be set"
    assert_not_nil borrow.due_date, "Due date should be set"
  end

  test "should not allow borrowing a book that is already borrowed" do
    Borrow.create!(user: @user, book: @book) # First borrow
    borrow = Borrow.new(user: User.create!(name: "Bob", email: "bob@example.com", password: "password123"), book: @book)

    assert_not borrow.save, "Should not allow borrowing an already borrowed book"
    assert_includes borrow.errors[:book], "is already borrowed"
  end

  test "should not allow user to borrow the same book twice without returning" do
    Borrow.create!(user: @user, book: @book)

    borrow = Borrow.new(user: @user, book: @book)
    assert_not borrow.save, "Should not allow borrowing the same book twice"
    assert_includes borrow.errors[:book], "has already been borrowed and not returned yet."
  end

  test "should not allow user to borrow a new book if they have an unreturned one" do
    book2 = Book.create!(title: "The Firm", author: "John Grisham", isbn: "978-0385319058")
    Borrow.create!(user: @user, book: @book)

    borrow = Borrow.new(user: @user, book: book2)
    assert_not borrow.save, "Should not allow borrowing a new book when a previous one is not returned"
    assert_includes borrow.errors[:base], "You must return your current book before borrowing a new one."
  end
end
