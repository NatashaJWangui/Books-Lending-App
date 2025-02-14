require 'test_helper'

class RegistrationsTest < ActionDispatch::IntegrationTest
  setup do
    @valid_user_params = { name: "Test User", email: "testuser@example.com", password: "password123", password_confirmation: "password123" }
    @invalid_user_params = { name: "", email: "invaliduser@example", password: "password123", password_confirmation: "password123" }
  end

  test "should display sign-up form" do
    get new_registration_url
    
    # Ensure the form fields and submit input are rendered correctly
    assert_select "h2", text: "Sign Up"
    assert_select "input[name='user[name]']"
    assert_select "input[name='user[email]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
    
    # Check if the submit input is rendered
    assert_select "input[type='submit']", 1
  end

  test "should sign up a user with valid details" do
    post registration_url, params: { user: @valid_user_params }
    
    # Ensure the user is redirected to the dashboard and success message is shown
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_select "div", text: "Signed up successfully!"
  end

  test "should not sign up a user with invalid details" do
    post registration_url, params: { user: @invalid_user_params }
    
    # Ensure the response status is 422 for unprocessable entity (form re-rendered)
    assert_response :unprocessable_entity
    assert_template :new
    
    # Check the flash alert is properly displayed on the current page
    assert_select "div.text-red-500", text: /Name can't be blank/
    assert_select "div.text-red-500", text: /Email is invalid/
  end

  test "should display flash alert for invalid user details" do
    post registration_url, params: { user: @invalid_user_params }
    
    # Ensure the flash error message appears on the same page
    assert_select "div.text-red-500", text: /Name can't be blank/
    assert_select "div.text-red-500", text: /Email is invalid/
  end
end
