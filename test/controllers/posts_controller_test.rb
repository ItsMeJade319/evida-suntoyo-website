require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should redirect new to sign in when not an admin" do
    get new_post_url
    assert_redirected_to new_admin_session_url
  end

  test "should get new when signed in as admin" do
    sign_in admins(:one)
    get new_post_url
    assert_response :success
  end

  test "should not create post when not an admin" do
    assert_no_difference("Post.count") do
      post posts_url, params: { post: {} }
    end

    assert_redirected_to new_admin_session_url
  end

  test "should create post when signed in as admin" do
    sign_in admins(:one)

    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "New Post" } }
    end

    assert_redirected_to admin_url
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should not show a draft post to the public" do
    get post_url(posts(:two))
    assert_response :not_found
  end

  test "should show a draft post to an admin" do
    sign_in admins(:one)
    get post_url(posts(:two))
    assert_response :success
  end

  test "index should not list draft posts to the public" do
    get posts_url
    assert_select "##{ActionView::RecordIdentifier.dom_id(posts(:two))}", false
  end

  test "index should list draft posts to an admin" do
    sign_in admins(:one)
    get posts_url
    assert_select "##{ActionView::RecordIdentifier.dom_id(posts(:two))}"
  end

  test "should redirect edit to sign in when not an admin" do
    get edit_post_url(@post)
    assert_redirected_to new_admin_session_url
  end

  test "should get edit when signed in as admin" do
    sign_in admins(:one)
    get edit_post_url(@post)
    assert_response :success
  end

  test "should not update post when not an admin" do
    patch post_url(@post), params: { post: {} }
    assert_redirected_to new_admin_session_url
  end

  test "should update post when signed in as admin" do
    sign_in admins(:one)
    patch post_url(@post), params: { post: { title: "Updated Title" } }
    assert_redirected_to admin_url
  end

  test "should not destroy post when not an admin" do
    assert_no_difference("Post.count") do
      delete post_url(@post)
    end

    assert_redirected_to new_admin_session_url
  end

  test "should destroy post when signed in as admin" do
    sign_in admins(:one)

    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to admin_url
  end
end
