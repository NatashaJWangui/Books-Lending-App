require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  setup do
    # Create a user for testing
    @user = User.create!(name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should display sign-in form" do
    # Visit the sign-in page
    get sign_in_path

    # Ensure the page contains the sign-in form with the appropriate fields
    assert_select "h2", text: "Sign In"
    assert_select "form[action='#{sign_in_path}']"
    assert_select "input[name='email']"
    assert_select "input[name='password']"

    # Check the submit button
    assert_select "input[type='submit']", 1

    # Ensure the links for password reset and sign-up are visible
    assert_select "a[href='#{new_password_path}']", text: "Reset it"
    assert_select "a[href='#{sign_up_path}']", text: "Sign Up"
  end

  test "should display flash alert for invalid sign-in" do
    # Attempt to sign in with invalid credentials
    post sign_in_path, params: { email: @user.email, password: "wrongpassword" }
    
    assert_equal "Try another email address or password.", flash[:alert]
    assert_redirected_to sign_in_path
  end

  test "should display flash notice for successful sign-in" do
    # Sign in with valid credentials
    post sign_in_path, params: { email: @user.email, password: "password123" }

    # Ensure redirection to the dashboard and the flash notice message
    assert_equal "Sign in successful.", flash[:notice]
    assert_redirected_to dashboard_path
  end
end
