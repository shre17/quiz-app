class SubmissionsController < ApplicationController
  
  def index
    @submissions = Submission.all
  end

  def show
    @submission = Submission.find(params[:id])
    @submission.form_values.each do |key,value|
      @question = @submission.test.questions.find_by("question like ?","#{key}%")
      @answer = @question.correct_answer
      if @answer == value
        puts "===============================true==============================="
        @score = @score.to_i + 1
      else
        puts "*******************************false*******************************"
      end
    end
  end

end
