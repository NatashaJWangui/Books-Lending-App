require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_user_params = { name: "Test User", email: "testuser@example.com", password: "password123", password_confirmation: "password123" }
    @invalid_user_params = { name: "", email: "invaliduser@example", password: "password123", password_confirmation: "password123" }
  end

  test "should get new" do
    get new_registration_path
    assert_response :success
  end

  test "should create user and sign in successfully" do
    assert_difference 'User.count', 1 do
      post sign_up_path, params: { user: @valid_user_params }
    end

    assert_redirected_to dashboard_url
    assert_equal "Signed up successfully!", flash[:notice]
  end

  test "should not create user with invalid params" do
    assert_no_difference 'User.count' do
      post sign_up_path, params: { user: @invalid_user_params }
    end

    assert_response :unprocessable_entity
    assert_template :new
    assert_includes flash[:alert], "Name can't be blank"
    assert_includes flash[:alert], "Email is invalid"
  end
end
