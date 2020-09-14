module LegislationQuestionsHelper
  def answer_url
    if @answer.persisted?
      legislation_process_question_answer_path(@process, @question, @answer)
    else
      legislation_process_question_answers_path(@process, @question)
    end
  end
end
