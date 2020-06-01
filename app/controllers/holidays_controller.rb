class HolidaysController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :holiday_params, except: [:create]


  respond_to :json

  def index
    @holidays = Holiday.all
    respond_with(@holidays)
  end

  def show
    respond_with(@holiday)
  end

  def new
    @holiday = Holiday.new
    respond_with(@holiday)
  end

  def edit
  end

  def create
    @holiday = Holiday.new(holiday_params)
    @holiday.save
    respond_with(@holiday)
  end

  def update
    @holiday.update(holiday_params)
    respond_with(@holiday)
  end

  def destroy
    @holiday.destroy
    respond_with(@holiday)
  end

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params.require(:holiday).permit(:name, :date, :bank_holiday)
    end
end
