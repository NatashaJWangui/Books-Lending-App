require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: "John Grisham", email: "  JOHN.GRISHAM@EXAMPLE.COM  ", password: "password123", password_confirmation: "password123")
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require a name" do
    @user.name = ""
    assert_not @user.valid?
    assert_includes @user.errors[:name], "can't be blank"
  end

  test "should require an email" do
    @user.email = ""
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "should not allow invalid email format" do
    @user.email = "invalid-email"
    assert_not @user.valid?
    assert_includes @user.errors[:email], "is invalid"
  end

  test "should normalize email to lowercase and remove spaces" do
    @user.save!
    assert_equal "john.grisham@example.com", @user.reload.email
  end

  test "should have a secure password" do
    assert @user.authenticate("password123")
    assert_not @user.authenticate("wrongpassword")
  end

  test "should require a password with a minimum length" do
    @user.password = @user.password_confirmation = "short"
    assert_not @user.valid?
  end

  test "should have many borrows" do
    assert_respond_to @user, :borrows
  end

  test "should have many borrowed books through borrows" do
    assert_respond_to @user, :borrowed_books
  end
end

