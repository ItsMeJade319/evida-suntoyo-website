require "test_helper"

class GuidesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guide = guides(:one)
  end

  test "should get index" do
    get guides_url
    assert_response :success
  end

  test "should redirect new to sign in when not an admin" do
    get new_guide_url
    assert_redirected_to new_admin_session_url
  end

  test "should get new when signed in as admin" do
    sign_in admins(:one)
    get new_guide_url
    assert_response :success
  end

  test "should not create guide when not an admin" do
    assert_no_difference("Guide.count") do
      post guides_url, params: { guide: {} }
    end

    assert_redirected_to new_admin_session_url
  end

  test "should create guide when signed in as admin" do
    sign_in admins(:one)

    assert_difference("Guide.count") do
      post guides_url, params: { guide: { title: "New Guide" } }
    end

    assert_redirected_to guide_url(Guide.last)
  end

  test "should create guide with nested steps when signed in as admin" do
    sign_in admins(:one)

    assert_difference([ "Guide.count", "GuideStep.count" ], 1) do
      post guides_url, params: { guide: {
        title: "Nested Steps Guide",
        steps_attributes: {
          "0" => { title: "Only step", content: "do the thing" }
        }
      } }
    end

    guide = Guide.last
    assert_redirected_to guide_url(guide)
    assert_equal [ "Only step" ], guide.steps.map(&:title)
  end

  test "should show guide" do
    get guide_url(@guide)
    assert_response :success
  end

  test "should not show a draft guide to the public" do
    get guide_url(guides(:two))
    assert_response :not_found
  end

  test "should show a draft guide to an admin" do
    sign_in admins(:one)
    get guide_url(guides(:two))
    assert_response :success
  end

  test "index should not list draft guides to the public" do
    get guides_url
    assert_select "##{ActionView::RecordIdentifier.dom_id(guides(:two))}", false
  end

  test "index should list draft guides to an admin" do
    sign_in admins(:one)
    get guides_url
    assert_select "##{ActionView::RecordIdentifier.dom_id(guides(:two))}"
  end

  test "should redirect edit to sign in when not an admin" do
    get edit_guide_url(@guide)
    assert_redirected_to new_admin_session_url
  end

  test "should get edit when signed in as admin" do
    sign_in admins(:one)
    get edit_guide_url(@guide)
    assert_response :success
  end

  test "should not update guide when not an admin" do
    patch guide_url(@guide), params: { guide: {} }
    assert_redirected_to new_admin_session_url
  end

  test "should update guide when signed in as admin" do
    sign_in admins(:one)
    patch guide_url(@guide), params: { guide: { title: "Updated Title" } }
    assert_redirected_to guide_url(@guide)
  end

  test "should not destroy guide when not an admin" do
    assert_no_difference("Guide.count") do
      delete guide_url(@guide)
    end

    assert_redirected_to new_admin_session_url
  end

  test "should destroy guide when signed in as admin" do
    sign_in admins(:one)

    assert_difference("Guide.count", -1) do
      delete guide_url(@guide)
    end

    assert_redirected_to guides_url
  end
end
