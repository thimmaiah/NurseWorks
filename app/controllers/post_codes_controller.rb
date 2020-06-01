class PostCodesController < ApplicationController
  #before_action :authenticate_user!
  load_and_authorize_resource param_method: :post_code_params, except: [:create]

  # GET /post_codes
  def index
    @post_codes = PostCode.search params[:search]
    render json: @post_codes
  end

  # GET /post_codes/1
  def show
    render json: @post_code
  end

  # POST /post_codes
  def create
    @post_code = PostCode.new(post_code_params)

    if @post_code.save
      render json: @post_code, status: :created, location: @post_code
    else
      render json: @post_code.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /post_codes/1
  def update
    if @post_code.update(post_code_params)
      render json: @post_code
    else
      render json: @post_code.errors, status: :unprocessable_entity
    end
  end

  # DELETE /post_codes/1
  def destroy
    @post_code.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post_code
      @post_code = PostCode.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_code_params
      params.require(:post_code).permit(:postcode, :latitude, :longitude)
    end
end
