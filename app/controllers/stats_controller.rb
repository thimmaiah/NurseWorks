class StatsController < ApplicationController
  before_action :set_stat, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @stats = Stat.all
    respond_with(@stats)
  end

  def show
    respond_with(@stat)
  end

  def new
    @stat = Stat.new
    respond_with(@stat)
  end

  def edit
  end

  def create
    @stat = Stat.new(stat_params)
    @stat.save
    respond_with(@stat)
  end

  def update
    @stat.update(stat_params)
    respond_with(@stat)
  end

  def destroy
    @stat.destroy
    respond_with(@stat)
  end

  private
    def set_stat
      @stat = Stat.find(params[:id])
    end

    def stat_params
      params.require(:stat).permit(:name, :description, :value)
    end
end
