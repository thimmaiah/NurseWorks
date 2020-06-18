class LessonsController < ApplicationController
  before_action :authenticate_user!  
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  respond_to :json

  def index

    results = []
    count = 0
    while !results.present? && count < 2
      qual = Riddle::Query.escape(current_user.key_qualifications)
      @lessons = Lesson.spx_key_qualifications(qual)
      
      spz = Riddle::Query.escape(current_user.specializations.shuffle.first)
      @lessons = @lessons.spx_specializations(spz)
      
      results = @lessons.search :limit=>5
      count += 1
    end
    respond_with(results)
  end

  def show
    respond_with(@lesson)
  end

  def new
    @lesson = Lesson.new
    respond_with(@lesson)
  end

  def edit
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.save
    respond_with(@lesson)
  end

  def update
    @lesson.update(lesson_params)
    respond_with(@lesson)
  end

  def destroy
    @lesson.destroy
    respond_with(@lesson)
  end

  private
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:title, :link, :link_type, :description, 
        :min_nq_score, :max_nq_score, :quiz_id, key_qualifications: [], specializations: [])
    end
end
