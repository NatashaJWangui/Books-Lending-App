require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "John Grisham",
      email: "john.grisham@example.com",
      password: "password123"
    )
    @book = books(:one) # Assuming you have a fixture for books
  end

  test "should get new" do
    log_in_as(@user)
    get new_book_url
    assert_response :success
  end

  test "should create book with valid attributes" do
    log_in_as(@user)
    assert_difference('Book.count', 1) do
      post books_url, params: { book: { title: 'New Book', author: 'Author Name', isbn: '1234567890', available: true, image_url: 'http://example.com/image.jpg', description: 'A great book.' } }
    end
    assert_redirected_to new_book_path
    follow_redirect!
    assert_select "div.text-green-500", "✅ 📚 Book successfully created!"
  end

  test "should not create book with invalid attributes" do
    log_in_as(@user)
    assert_no_difference('Book.count') do
      post books_url, params: { book: { title: '', author: '', isbn: '', available: nil, image_url: '', description: '' } }
    end
    assert_response :unprocessable_entity
    assert_select "div.text-red-500" do
        assert_select "li", "❌ Title cannot be blank"
        assert_select "li", "❌ Author cannot be blank"
        assert_select "li", "❌ Isbn cannot be blank"
    end
  end

  def log_in_as(user)
    post sign_in_path, params: { email: user.email, password: "password123" }
  end
end
