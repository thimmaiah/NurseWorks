class RatesController < ApplicationController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @rates = Rate.all
    respond_with(@rates)
  end

  def show
    respond_with(@rate)
  end

  def new
    @rate = Rate.new
    respond_with(@rate)
  end

  def edit
  end

  def create
    @rate = Rate.new(rate_params)
    @rate.save
    respond_with(@rate)
  end

  def update
    @rate.update(rate_params)
    respond_with(@rate)
  end

  def destroy
    @rate.destroy
    respond_with(@rate)
  end

  private
    def set_rate
      @rate = Rate.find(params[:id])
    end

    def rate_params
      params.require(:rate).permit(:city, :role, :speciality, :amount)
    end
end
