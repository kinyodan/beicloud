require "test_helper"

class GitControlControllerTest < ActionDispatch::IntegrationTest
  test "should get clone_repo" do
    get git_control_clone_repo_url
    assert_response :success
  end

  test "should get index" do
    get git_control_index_url
    assert_response :success
  end
end
