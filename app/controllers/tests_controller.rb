class TestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  # GET /tests
  # GET /tests.json
  def index
    @tests = Test.all
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
  end

  # GET /tests/new
  def new
    @test = Test.new
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)

    respond_to do |format|
      if @test.save
        format.html { redirect_to @test, notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: @test }
      else
        format.html { render :new }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to tests_url, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def preview_test
    @test = Test.find(params[:id])
    if @test.present?
      @test_questions = @test.questions
    end
  end

  def previous_question
    @test = Test.find(params[:id])
    @question  = Question.find(params[:question_id])
    @pre_quest = @test.questions.where(["id < ?", @question.id]).last
  end

  def next_question
    @test = Test.find(params[:id])
    @question  = Question.find(params[:question_id])
    @next_quest = @test.questions.where(["id > ?", @question.id]).first
  end

  def question_list
    @test = Test.find(params[:id])
    @ques = Question.find(params[:question_id])
    @question = @test.questions.find_by(id: @ques)
  end

  def collect_user_response
    form_block_ids = {}
    
    @test = Test.find(params[:user_response][:test_id])
        
    @user = User.find(params[:user_response][:user_id])
    
    total_response_value = params[:user_response]
    
    submission_values = {"user_id" => params[:user_response][:user_id], "test_id" => params[:user_response][:test_id], "submission_id" => params[:user_response][:submission_id]}

    puts submission_values
    
    test_form_values = total_response_value.dup.delete_if {|k,_| submission_values.key?(k)}
    
    test_form_values.each {|k, v| puts form_block_ids[k] = v if k.include? "test_form_"}
    
    puts form_block_ids
    
    test_form_values = total_response_value.dup.delete_if {|k,_| submission_values.merge(form_block_ids).key?(k)}
    
    puts test_form_values

    if params[:user_response][:submission_id].present?
      @submission = Submission.find(params[:user_response][:submission_id])
      submission_form_values = @submission.form_values
      new_submission_form_values = total_response_value.dup.delete_if {|k,_| submission_values.key?(k)}
      updated_submission_form_values = test_form_values.merge(submission_form_values)
      respond_to do |format|
        if @submission.update(form_values: updated_submission_form_values)
          format.html { redirect_to test_path(@test), notice: 'your response has been collected successfully. Thanks for responding :)' }
        else 
          format.html { redirect_to preview_test_test_path(@test.id, submission_id: @submission.id), notice: 'your response for this this step has been collected successfully. Please respond for next step :)' }
        end
      end
    else
      @submission = Submission.new(user_id: @user.id, test_id: @test.id, form_values: test_form_values)
      respond_to do |format|
        if @submission.save 
          format.html { redirect_to test_path(@test), notice: 'your response has been collected successfully. Thanks for responding :)' }
        else
          format.html { redirect_to preview_test_test_path(@test.id, submission_id: @submission.id), notice: 'your response for this this step has been collected successfully. Please respond for next step :)' }
        end
      end
    end
  end

  def submissions
    @test = Test.find(params[:id])
    @submissions = @test.submissions

    respond_to do |format|
      format.html
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(:name, questions_attributes: [:id, :question, :correct_answer, :done, :_destroy,choices_attributes: [:id, :name, :done, :_destroy]])
    end
end
