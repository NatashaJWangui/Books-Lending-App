require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should get new session page" do
    get sign_in_path
    assert_response :success
  end

  test "should sign in with valid credentials" do
    post sign_in_path, params: { email: @user.email, password: "password123" }
    
    assert_redirected_to dashboard_path
    assert_equal "Sign in successful.", flash[:notice]
  end

  test "should not sign in with invalid credentials" do
    post sign_in_path, params: { email: @user.email, password: "wrongpassword" }
    
    assert_redirected_to sign_in_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "should log out successfully" do
    post sign_in_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to dashboard_path

    delete logout_path
    
    assert_redirected_to sign_in_path
    assert_equal "You have been logged out successfully.", flash[:notice]
  end
end
