class AnswersController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question = Question.find(params[:question_id])
    if @answer.save
      redirect_to questions_path
    else
      render :new
    end
  end

private
  def answer_params
    params.require(:answer).permit(:answer_text)

end

end
