require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "should not save book without title" do
    book = Book.new(author: "John Doe", isbn: "123456789")
    assert_not book.save, "Saved the book without a title"
  end

  test "should not save book without author" do
    book = Book.new(title: "Test Book", isbn: "123456789")
    assert_not book.save, "Saved the book without an author"
  end

  test "should not save book with duplicate ISBN" do
    book1 = Book.create(title: "Book One", author: "Author A", isbn: "111111")
    book2 = Book.new(title: "Book Two", author: "Author B", isbn: "111111")
    assert_not book2.save, "Saved a book with duplicate ISBN"
  end
end
