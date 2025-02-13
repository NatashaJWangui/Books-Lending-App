require "application_system_test_case"

class BookListingTest < ApplicationSystemTestCase
  test "visiting the book index" do
    visit books_path
    assert_selector "h1", text: "Available Books"
  end

  test "book details page" do
    book = Book.create(title: "Sample Book", author: "Author", isbn: "123456")
    visit book_path(book)
    assert_text "Sample Book"
    assert_text "Author"
  end
end
