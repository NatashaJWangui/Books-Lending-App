require 'test_helper'
include Rails.application.routes.url_helpers # Include path helpers

class BorrowsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  def setup
    @user = users(:one) # Use an existing user fixture
    @book = books(:one) # Use an existing book fixture
  end

  # Simulate logging in a user
  def login(user)
    post sign_in_path, params: { email: user.email, password: 'password' }
  end

  test "should get index" do
    login(@user)  # Log in the user

    # Access the borrows index
    get borrows_path
    assert_response :success

    # Assert that the borrows are rendered
    assert_select "h2", "Your Borrowed Books"
  end

  test "should borrow a book successfully" do
    login(@user)  # Log in the user

    # Ensure that the user can borrow a book
    assert_difference 'Borrow.count', 1 do
      post book_borrow_path(@book.id)
    end

    # Check if the user is redirected to the book page after borrowing
    assert_redirected_to book_path(@book)
    follow_redirect!
    assert_select "div.alert", "You have successfully borrowed '#{@book.title}'."
  end

  test "should not borrow a book if already borrowed" do
    login(@user)  # Log in the user

    # Borrow the book for the first time
    post book_borrow_path(@book.id)

    # Try to borrow the same book again
    post book_borrow_path(@book.id)

    # Assert that the borrow count has not increased and the user gets an alert
    assert_no_difference 'Borrow.count' do
      post book_borrow_path(@book.id)
    end
    assert_redirected_to book_path(@book)
    follow_redirect!
    assert_select "div.alert", "You have already borrowed this book and must return it first."
  end

  test "should return a borrowed book" do
    login(@user)  # Log in the user

    # Borrow the book first
    post book_borrow_path(@book.id)

    # Now return the book
    borrow = @user.borrows.last
    patch borrow_path(borrow)

    # Assert the book is marked as returned and redirected to borrows index
    assert_equal borrow.reload.returned_at.to_date, Date.today
    assert_redirected_to borrows_path
    follow_redirect!
    assert_select "div.alert", "You have successfully returned '#{@book.title}'."
  end

  test "should not return a book if already returned" do
    login(@user)  # Log in the user

    # Borrow and return the book first
    post book_borrow_path(@book.id)
    borrow = @user.borrows.last
    patch borrow_path(borrow)

    # Try to return the book again
    patch borrow_path(borrow)

    # Assert that the returned_at attribute doesn't change
    assert_no_changes 'borrow.reload.returned_at' do
      patch borrow_path(borrow)
    end
    assert_redirected_to borrows_path
    follow_redirect!
    assert_select "div.alert", "This book has already been returned."
  end
end
