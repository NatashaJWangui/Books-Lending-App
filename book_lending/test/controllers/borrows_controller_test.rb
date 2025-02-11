require "test_helper"

class BorrowsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get borrows_create_url
    assert_response :success
  end

  test "should get return" do
    get borrows_return_url
    assert_response :success
  end
end
