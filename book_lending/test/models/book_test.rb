require "test_helper"

class BookTest < ActiveSupport::TestCase
  def setup
    @book = Book.new(title: "The Firm", author: "John Grisham", isbn: "9780385416344")
  end

  test "should be valid with valid attributes" do
    assert @book.valid?
  end

  test "should be invalid without a title" do
    @book.title = ""
    assert_not @book.valid?
    assert_includes @book.errors[:title], "cannot be blank"
  end

  test "should be invalid without an author" do
    @book.author = ""
    assert_not @book.valid?
    assert_includes @book.errors[:author], "cannot be blank"
  end

  test "should be invalid without an isbn" do
    @book.isbn = ""
    assert_not @book.valid?
    assert_includes @book.errors[:isbn], "cannot be blank"
  end

  test "should have a unique isbn" do
    duplicate_book = @book.dup
    @book.save
    assert_not duplicate_book.valid?
    assert_includes duplicate_book.errors[:isbn], "must be unique"
  end

  test "should be available when no active borrows exist" do
    @book.save
    assert @book.available?
  end

  test "should not be available if there is an active borrow" do
    @book.save
    user = User.create!(name: "Test User", email: "test@example.com", password: "password123")
    Borrow.create!(book: @book, user: user, borrowed_at: Time.now, returned_at: nil)

    assert_not @book.available?
  end
end
