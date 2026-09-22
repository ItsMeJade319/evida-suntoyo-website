class PostsController < ApplicationController
  before_action :authenticate_admin!, except: %i[ index show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :ensure_visible!, only: %i[ show ]

  # GET /posts or /posts.json
  def index
    @posts = Post.published
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to safe_redirect_target(admin_path), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @post.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to safe_redirect_target(admin_path), notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @post.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to safe_redirect_target(posts_path), notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by!(slug: params.expect(:id))
    end

    # Drafts are only visible to the signed-in admin previewing them.
    def ensure_visible!
      raise ActiveRecord::RecordNotFound unless @post.published? || admin_signed_in?
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :slug, :body, :published, :image ])
    end
end
