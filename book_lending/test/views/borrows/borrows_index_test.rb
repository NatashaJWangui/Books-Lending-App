require 'test_helper'

class BorrowsControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Dynamically create a user
    @user = User.create!(
      name: "John Grisham",
      email: "john.grisham@example.com",
      password: "password123"
    )

    # Dynamically create a book
    @book = Book.create!(
      title: "The Firm",
      author: "John Grisham",
      isbn: "9780385339706",
      description: "A legal thriller",
      image_url: "http://example.com/the_firm.jpg",
      available: true # Set it as available for borrowing
    )

    # Log in the user
    log_in_as(@user)
  end

  test "should show borrowed books" do
    # Dynamically create a borrow record
    @borrow = Borrow.create!(
      user: @user,
      book: @book,
      borrowed_at: Time.zone.now,
      due_date: Time.zone.now + 2.weeks,
      returned_at: nil # Book is not returned yet
    )

    puts "Borrow record created: #{@borrow.inspect}"

    get borrows_path

    assert_response :success
    assert_select 'h2', "Your Borrowed Books"
    assert_select 'table' do
      assert_select 'tr' # At least one book should be listed
      assert_select 'td', text: @book.title  # Book title should be displayed
      assert_select 'span', /Borrowed/ if borrow.returned_at.present?
      assert_select 'td', text: @borrow.due_date.strftime('%d-%m-%Y %I:%M %p')  # Due date should be shown
    end
  end

  test "should show flash notice when borrowing a book" do
    # Dynamically create a borrow record
    @borrow = Borrow.create!(
      user: @user,
      book: @book,
      borrowed_at: Time.zone.now,
      due_date: Time.zone.now + 2.weeks,
      returned_at: nil # Book is not returned yet
    )

    # Attempt to borrow the same book again
    post book_borrow_path(@book.id)
    follow_redirect!
    assert_select "div.alert", text: "You have already borrowed this book and must return it first."
  end

  test "should successfully borrow a different book" do
    # Dynamically create a second book
    @book2 = Book.create!(
      title: "The Pelican Brief",
      author: "John Grisham",
      isbn: "9780385339713",
      description: "A legal thriller",
      image_url: "http://example.com/the_pelican_brief.jpg",
      available: true  # Set it as available for borrowing
    )
    @borrow2 = Borrow.create!(
      user: @user,
      book: @book2,
      borrowed_at: Time.zone.now,
      due_date: Time.zone.now + 2.weeks,
      returned_at: nil # Book is not returned yet
    )

    # Borrow the new book
    post book_borrow_path(@book2.id)
    follow_redirect!

    puts flash[:alert] 
    
    
    # Adjusted assertion to match new flash message format (including the due date)
    assert_select 'div.alert', text: "You have successfully borrowed '#{@book2.title}'. Due date: #{@borrow2.due_date.strftime('%d-%m-%Y %I:%M %p')}."
  end

  private

  def log_in_as(user)
    post sign_in_path, params: { email: user.email, password: "password123" }
  end
end
