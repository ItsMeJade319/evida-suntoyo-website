class AdminController < ApplicationController
  before_action :authenticate_admin!

  def show
    @projects = Project.all
    @posts = Post.all
  end
end
