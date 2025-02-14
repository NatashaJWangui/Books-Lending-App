require "test_helper"

class BooksEditTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "John Grisham",
      email: "john.grisham@example.com",
      password: "password123"
    )
    @book = Book.create!(
      title: "The Firm",
      author: "John Grisham",
      isbn: "1234567890",
      image_url: "https://example.com/firm.jpg",
      description: "A young lawyer joins a corrupt law firm.",
      available: true
    )
  end

  test "edit book form displays correctly" do
    log_in_as(@user)

    get edit_book_path(@book)
    assert_response :success

    assert_select "h1", "Edit Book"
    assert_select "form[action=?]", book_path(@book) do
      assert_select "input[name=?][value=?]", "book[title]", @book.title
      assert_select "input[name=?][value=?]", "book[author]", @book.author
      assert_select "input[name=?][value=?]", "book[isbn]", @book.isbn
      assert_select "textarea[name=?]", "book[description]", text: @book.description
      assert_select "input[type=submit][value=?]", "Save"
    end
  end

  test "successful book update" do
    log_in_as(@user)

    patch book_path(@book), params: { book: { title: "The Pelican Brief" } }
    assert_redirected_to book_path(@book)
    follow_redirect!
    assert_select ".alert-success", "Book updated successfully."
    assert_select "h1", "The Pelican Brief"
  end

  private

  def log_in_as(user)
    post sign_in_path, params: { email: user.email, password: "password123" }
  end
end
