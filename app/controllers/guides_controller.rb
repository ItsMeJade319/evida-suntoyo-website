class GuidesController < ApplicationController
  before_action :authenticate_admin!, except: %i[ index show ]
  before_action :set_guide, only: %i[ show edit update destroy ]
  before_action :ensure_visible!, only: %i[ show ]

  # GET /guides or /guides.json
  def index
    @guides = Guide.published
  end

  # GET /guides/1 or /guides/1.json
  def show
  end

  # GET /guides/new
  def new
    @guide = Guide.new
  end

  # GET /guides/1/edit
  def edit
  end

  # POST /guides or /guides.json
  def create
    @guide = Guide.new(guide_params)

    respond_to do |format|
      if @guide.save
        format.html { redirect_to safe_redirect_target(admin_path), notice: "Guide was successfully created." }
        format.json { render :show, status: :created, location: @guide }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @guide.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /guides/1 or /guides/1.json
  def update
    respond_to do |format|
      if @guide.update(guide_params)
        format.html { redirect_to safe_redirect_target(admin_path), notice: "Guide was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @guide }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @guide.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /guides/1 or /guides/1.json
  def destroy
    @guide.destroy!

    respond_to do |format|
      format.html { redirect_to safe_redirect_target(guides_path), notice: "Guide was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guide
      @guide = Guide.find_by!(slug: params.expect(:id))
    end

    # Drafts are only visible to the signed-in admin previewing them.
    def ensure_visible!
      raise ActiveRecord::RecordNotFound unless @guide.published? || admin_signed_in?
    end

    # Only allow a list of trusted parameters through.
    def guide_params
      params.expect(guide: [ :title, :description, :slug, :published, :image,
        steps_attributes: [ [ :id, :title, :content, :image, :position, :_destroy ] ] ])
    end
end
