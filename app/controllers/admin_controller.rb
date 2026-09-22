class AdminController < ApplicationController
  before_action :authenticate_admin!

  def show
    @guides = Guide.all
    @posts = Post.all
  end
end
