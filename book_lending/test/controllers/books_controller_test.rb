require "test_helper"
include Rails.application.routes.url_helpers

class BooksControllerTest < ActionDispatch::IntegrationTest
  # Setup some books for testing
  def setup
    @user = users(:one)
    @book1 = books(:one) # Assuming you have a fixture for books
    @book2 = books(:two)
  end
  
  # Simulate logging in a user
  def login(user)
    post sign_in_path, params: { email: user.email, password: 'password' }
  end

  test "should get index without query" do
    login(@user)
    get books_url
    assert_response :success
    assert_select "h1", "Books" # Adjust as per your view content
  end

  test "should get index with query" do
    login(@user)
    get books_url, params: { query: @book1.title }
    assert_response :success
    assert_select "h1", "Books"
  end

  test "should show book" do
    login(@user)
    get book_url(@book1)
    assert_response :success
    assert_select "h1", @book1.title
  end
  

  test "should create book" do
    login(@user)
    assert_difference('Book.count', 1) do
      post books_url, params: { book: { title: "New Book", author: "New Author", isbn: "12345", available: true, image_url: "image.jpg", description: "A description" } }
    end
    assert_redirected_to new_book_path
    assert_equal "📚 Book successfully created!", flash[:notice]
  end
  
  test "should not create book with invalid data" do
    login(@user)
    assert_no_difference('Book.count') do
      post books_url, params: { book: { title: "", author: "", isbn: "", available: false, image_url: "", description: "" } }
    end
    assert_response :unprocessable_entity
    assert_match "🚨 Oops! Please correct the errors below.", flash[:alert]
  end

  test "should destroy book" do
    login(@user)
    assert_difference('Book.count', -1) do
      delete book_url(@book1)
    end
    assert_redirected_to books_url # Fixed redirect path
    assert_equal "Book deleted successfully.", flash[:notice]
  end
end
