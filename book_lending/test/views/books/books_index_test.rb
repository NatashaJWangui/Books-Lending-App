require "test_helper"

class BooksIndexTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Admin User", email: "admin@example.com", password: "password")
    @user = User.create!(name: "Regular User", email: "user@example.com", password: "password")
    
    @book1 = Book.create!(title: "The Firm", author: "John Grisham", isbn: "0-385-41634-2", available: true)
    @book2 = Book.create!(title: "Clean Code", author: "Robert C. Martin", isbn: "978-0132350884", available: false)
  end

  test "index page renders correctly" do
    sign_in_as(@user)
    get books_path
    assert_response :success
    assert_select "h1", text: "Books"
  end

  test "books are listed correctly" do
    sign_in_as(@user)
    get books_path
    assert_select "td", text: "The Firm"
    assert_select "td", text: "Clean Code"
  end

  test "borrow button only for available books" do
    sign_in_as(@user)
    get books_path
    assert_select "button", text: "Borrow", count: Book.where(available: true).count
  end

  test "admin sees edit and delete buttons" do
    sign_in_as(@admin)
    get books_path
    assert_select "a", text: "Edit", count: Book.count
    assert_select "button", text: "Delete", count: Book.count
  end

  test "regular user does not see edit and delete buttons" do
    sign_in_as(@user)
    get books_path
    assert_select "a", text: "Edit", count: 0
    assert_select "button", text: "Delete", count: 0
  end

  test "search functionality works" do
    get books_path, params: { query: "The Firm" }
    assert_select "td", text: "The Firm"
    assert_select "td", text: "Clean Code", count: 0 # Should not appear
  end

  private

  def sign_in_as(user)
    post sign_in_path, params: { email: user.email, password: "password" }
  end
end
