require "test_helper"

class Api::UrlsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_urls_create_url
    assert_response :success
  end
end
