require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create a user dynamically
    @user = User.create!(
      name: "John Grisham",
      email: "john.grisham@example.com",
      password: "password123"
    )
    
    # Create a book dynamically or use the fixture
    @book = Book.create!(
      title: "The Firm",
      author: "John Grisham",
      isbn: "9780385339706",
      description: "A legal thriller",
      image_url: "http://example.com/the_firm.jpg",
      available: true  # Set it as available for borrowing
    )
    
    # Create a borrow record dynamically for testing
    @borrow = Borrow.create!(
      user: @user,
      book: @book,
      borrowed_at: Time.now,
      due_date: Time.now + 2.weeks,
      returned_at: nil  # This keeps the book as not returned
    )
    
    # Create an admin user dynamically
    @admin = User.create!(
      name: "Admin User",
      email: "admin@example.com",
      password: "password123"
    )
  end

  test "should show book with correct details" do
    log_in_as(@user)
    get book_url(@book)

    assert_response :success
    assert_select 'h1', @book.title
    assert_select 'p', /Author: #{@book.author}/
    assert_select 'p', /ISBN: #{@book.isbn}/
    expected_description = @book.description.presence || "No description available for this book."
    assert_select 'p', /Description:\s*#{expected_description}/
    assert_select 'span', /Available/ if @book.available?
    assert_select 'span', /Borrowed/ unless @book.available?
  end

  test "should show 'no image available' if book has no image_url" do
    log_in_as(@user)
    @book.update(image_url: nil)  # Update book to have no image_url
    get book_url(@book)

    assert_response :success
    assert_select 'p', 'No image available'
  end

  test "should display borrow button when book is available and user has no unreturned books" do
    log_in_as(@user)
    # Simulating no unreturned books for the user (this user has no unreturned books)
    @user.borrows.update_all(returned_at: Time.now)  # Ensure there are no unreturned books
    get book_url(@book)
    assert_select 'button', 'Borrow Book'
  end

  test "should disable borrow button if user has an unreturned book" do
    log_in_as(@user)
    # The @borrow record was created with `returned_at` as nil, simulating an unreturned book
    get book_url(@book)
    assert_select 'button', 'Return'
  end

  test "should show edit link if user is admin" do
    log_in_as(@admin)
    get book_url(@book)

    assert_select 'a', 'Edit'
  end

  test "should not show edit link if user is not admin" do
    log_in_as(@user)
    get book_url(@book)

    assert_select 'a', { count: 0, text: 'Edit' }
  end

  def log_in_as(user)
    post sign_in_path, params: { email: user.email, password: "password123" }
  end
end
