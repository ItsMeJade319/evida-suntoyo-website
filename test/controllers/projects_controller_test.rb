require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should redirect new to sign in when not an admin" do
    get new_project_url
    assert_redirected_to new_admin_session_url
  end

  test "should get new when signed in as admin" do
    sign_in admins(:one)
    get new_project_url
    assert_response :success
  end

  test "should not create project when not an admin" do
    assert_no_difference("Project.count") do
      post projects_url, params: { project: {} }
    end

    assert_redirected_to new_admin_session_url
  end

  test "should create project when signed in as admin" do
    sign_in admins(:one)

    assert_difference("Project.count") do
      post projects_url, params: { project: { title: "New Project" } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should redirect edit to sign in when not an admin" do
    get edit_project_url(@project)
    assert_redirected_to new_admin_session_url
  end

  test "should get edit when signed in as admin" do
    sign_in admins(:one)
    get edit_project_url(@project)
    assert_response :success
  end

  test "should not update project when not an admin" do
    patch project_url(@project), params: { project: {} }
    assert_redirected_to new_admin_session_url
  end

  test "should update project when signed in as admin" do
    sign_in admins(:one)
    patch project_url(@project), params: { project: { title: "Updated Title" } }
    assert_redirected_to project_url(@project)
  end

  test "should not destroy project when not an admin" do
    assert_no_difference("Project.count") do
      delete project_url(@project)
    end

    assert_redirected_to new_admin_session_url
  end

  test "should destroy project when signed in as admin" do
    sign_in admins(:one)

    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
