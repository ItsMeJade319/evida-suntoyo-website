require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "redirects to sign in when not an admin" do
    get admin_url
    assert_redirected_to new_admin_session_url
  end

  test "shows the dashboard when signed in as admin" do
    sign_in admins(:one)
    get admin_url
    assert_response :success
  end

  test "returns to the dashboard after signing in from the admin link" do
    get admin_url
    assert_redirected_to new_admin_session_url

    post admin_session_url, params: { admin: { email: admins(:one).email, password: "password" } }
    assert_redirected_to admin_url
  end
end
