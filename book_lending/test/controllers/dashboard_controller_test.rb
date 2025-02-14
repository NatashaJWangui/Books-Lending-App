require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should redirect unauthenticated user to login" do
    get dashboard_path

    puts "🚀 FLASH BEFORE REDIRECT: #{flash[:alert].inspect}"
    assert_redirected_to sign_in_path

    follow_redirect!

    puts "🛑 FLASH AFTER REDIRECT: #{flash[:alert].inspect}"

    assert flash[:alert].present?, "Flash message should still be present after redirect"
    assert_equal "Please log in to continue.", flash[:alert]
  end

  test "should allow authenticated user to access dashboard" do
    post sign_in_path, params: { email: @user.email, password: "password" } 
    follow_redirect!

    get dashboard_path
    assert_response :success
  end
end
