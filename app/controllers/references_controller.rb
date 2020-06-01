class ReferencesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :references_params, except: [:create]


  respond_to :json

  def index
    respond_with(@references)
  end

  def show
    respond_with(@reference)
  end

  def new
    @reference = Reference.new
    respond_with(@reference)
  end

  def edit
  end

  def create
    @reference = Reference.new(reference_params)
    @reference.user_id = current_user.id
    @reference.save
    respond_with(@reference)
  end

  def update
    @reference.update(reference_params)
    respond_with(@reference)
  end

  def destroy
    @reference.destroy
    respond_with(@reference)
  end

  private
    def reference_params
      params.require(:reference).permit(:first_name, :last_name, :title, :email, :ref_type, :user_id, :address)
    end
end
